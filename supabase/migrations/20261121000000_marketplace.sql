-- FDE 101 Workshop 2.1: multi-vendor marketplace ("fde-shop"), a separate Supabase project from the ERP.
--
-- Rules (decided with the user, 2026-11-21):
--   Accounts      anyone can register as buyer or seller, but only through our API (it creates the Supabase Auth user
--                 with app_metadata.via = 'api'; a trigger refuses any other sign-up). A seller gets one shop.
--                 Platform admins are created by script. A banned user cannot do anything (every function checks).
--   Data access   users have no table grants (RLS on, no policies); every read / write goes through the functions
--                 below, which check the caller first. Buyers see only their own orders, sellers only their own shop.
--   Money         prices, discounts, shipping and totals are computed here, never taken from the browser.
--                 Shipping THB 40 per shop order, free from THB 500 after discount. Platform fee 5 % of
--                 (subtotal - shop discount); platform-coupon discounts are paid by the platform, not the seller.
--   Coupons       percent or fixed, minimum spend, optional cap, start / expiry, total and per-user limits. Shop coupons
--                 (promotions) work only in that shop; platform coupons (campaigns) work in every shop. One coupon per
--                 order. Checked and redeemed in the checkout transaction with the coupon row locked.
--   Stock         stock_qty per product, decremented atomically at checkout (stock_qty >= qty, else the whole
--                 checkout fails); every change is a stock_movements row; cancelled orders and refunds of unshipped
--                 orders put stock back. Low stock = stock_qty <= low_stock_threshold.
--   Orders        one order per shop. PENDING_PAYMENT -> TO_SHIP (seller approves the transfer slip) -> SHIPPED
--                 (carrier + tracking number) -> DELIVERED; CANCELLED (unpaid only) or REFUNDED (seller approves a
--                 buyer's refund request). Every change is a shipment_events row (the tracking timeline).
--   Slips         uploaded to Storage bucket payment-slips/<buyer uid>/<order id>/...; trans_ref is unique, so a slip
--                 cannot be used twice. The seller checks it and approves or rejects (no external slip API).

begin;

-- ---------------------------------------------------------------- tables
create table public.profiles (
    user_id      uuid primary key references auth.users(id) on delete cascade,
    email        text not null unique,
    display_name text not null,
    role         text not null check (role in ('buyer', 'seller', 'admin')),
    status       text not null default 'active' check (status in ('active', 'banned')),
    ban_reason   text,
    created_at   timestamptz not null default now()
);

create table public.shops (
    shop_id     bigint generated always as identity primary key,
    owner_id    uuid not null unique references public.profiles(user_id) on delete cascade,
    name        text not null unique check (length(name) between 2 and 60),
    description text,
    created_at  timestamptz not null default now()
);

create table public.categories (
    category_id integer generated always as identity primary key,
    name        text not null unique
);

create table public.products (
    product_id          bigint generated always as identity primary key,
    shop_id             bigint not null references public.shops(shop_id) on delete cascade,
    name                text not null check (length(name) between 2 and 120),
    description         text,
    category_id         integer references public.categories(category_id),
    price               numeric(12, 2) not null check (price > 0),
    image_url           text,
    stock_qty           integer not null default 0 check (stock_qty >= 0),
    low_stock_threshold integer not null default 5 check (low_stock_threshold >= 0),
    is_active           boolean not null default true,
    created_at          timestamptz not null default now()
);
create index ix_products_shop on public.products (shop_id);

create table public.cart_items (
    user_id    uuid not null references public.profiles(user_id) on delete cascade,
    product_id bigint not null references public.products(product_id) on delete cascade,
    qty        integer not null check (qty between 1 and 99),
    added_at   timestamptz not null default now(),
    primary key (user_id, product_id)
);

create table public.campaigns (
    campaign_id bigint generated always as identity primary key,
    name        text not null,
    description text,
    starts_at   timestamptz not null,
    ends_at     timestamptz not null check (ends_at > starts_at),
    created_by  uuid references public.profiles(user_id),
    created_at  timestamptz not null default now()
);
create table public.campaign_products (
    campaign_id bigint not null references public.campaigns(campaign_id) on delete cascade,
    product_id  bigint not null references public.products(product_id) on delete cascade,
    primary key (campaign_id, product_id)
);

create table public.coupons (
    coupon_id            bigint generated always as identity primary key,
    code                 text not null unique check (code ~ '^[A-Z0-9]{3,20}$'),
    shop_id              bigint references public.shops(shop_id) on delete cascade,   -- null = platform coupon
    campaign_id          bigint references public.campaigns(campaign_id) on delete set null,
    discount_type        text not null check (discount_type in ('PERCENT', 'FIXED')),
    discount_value       numeric(12, 2) not null check (discount_value > 0),
    max_discount         numeric(12, 2) check (max_discount > 0),
    min_order_amount     numeric(12, 2) not null default 0 check (min_order_amount >= 0),
    usage_limit_total    integer check (usage_limit_total > 0),
    usage_limit_per_user integer not null default 1 check (usage_limit_per_user > 0),
    starts_at            timestamptz not null default now(),
    expires_at           timestamptz not null,
    is_active            boolean not null default true,
    created_at           timestamptz not null default now(),
    check (discount_type <> 'PERCENT' or discount_value <= 90),
    check (expires_at > starts_at)
);

create table public.orders (
    order_id         bigint generated always as identity primary key,
    order_number     text not null unique,
    buyer_id         uuid not null references public.profiles(user_id),
    shop_id          bigint not null references public.shops(shop_id),
    status           text not null check (status in ('PENDING_PAYMENT', 'TO_SHIP', 'SHIPPED', 'DELIVERED', 'CANCELLED', 'REFUNDED')),
    subtotal         numeric(12, 2) not null,
    discount         numeric(12, 2) not null default 0,
    shipping_fee     numeric(12, 2) not null,
    total            numeric(12, 2) not null check (total >= 0),
    coupon_id        bigint references public.coupons(coupon_id),
    coupon_code      text,
    platform_funded  boolean not null default false,
    ship_name        text not null,
    ship_phone       text not null,
    ship_address     text not null,
    created_at       timestamptz not null default now(),
    pay_by           timestamptz not null,
    paid_at          timestamptz,
    shipped_at       timestamptz,
    delivered_at     timestamptz,
    cancelled_at     timestamptz,
    cancel_reason    text,
    carrier          text,
    tracking_number  text
);
create index ix_orders_buyer on public.orders (buyer_id, created_at desc);
create index ix_orders_shop on public.orders (shop_id, created_at desc);

create table public.order_items (
    order_id   bigint not null references public.orders(order_id) on delete cascade,
    line_no    integer not null,
    product_id bigint not null references public.products(product_id),
    name       text not null,
    unit_price numeric(12, 2) not null,
    qty        integer not null check (qty > 0),
    line_total numeric(12, 2) not null,
    primary key (order_id, line_no)
);

create table public.coupon_redemptions (
    redemption_id   bigint generated always as identity primary key,
    coupon_id       bigint not null references public.coupons(coupon_id),
    user_id         uuid not null references public.profiles(user_id),
    order_id        bigint not null unique references public.orders(order_id) on delete cascade,
    discount_amount numeric(12, 2) not null,
    created_at      timestamptz not null default now()
);

create table public.shipment_events (
    event_id   bigint generated always as identity primary key,
    order_id   bigint not null references public.orders(order_id) on delete cascade,
    status     text not null,
    note       text,
    created_by uuid references public.profiles(user_id),
    created_at timestamptz not null default now()
);
create index ix_events_order on public.shipment_events (order_id, event_id);

create table public.stock_movements (
    movement_id bigint generated always as identity primary key,
    product_id  bigint not null references public.products(product_id) on delete cascade,
    qty_change  integer not null check (qty_change <> 0),
    reason      text not null check (reason in ('INITIAL', 'RESTOCK', 'ADJUST', 'SALE', 'CANCEL', 'REFUND')),
    order_id    bigint references public.orders(order_id) on delete set null,
    note        text,
    created_by  uuid references public.profiles(user_id),
    created_at  timestamptz not null default now()
);
create index ix_moves_product on public.stock_movements (product_id, movement_id desc);

create table public.payment_slips (
    slip_id     bigint generated always as identity primary key,
    order_id    bigint not null references public.orders(order_id) on delete cascade,
    trans_ref   text not null unique check (length(trans_ref) between 6 and 40),
    amount      numeric(12, 2) not null check (amount > 0),
    slip_path   text not null,
    status      text not null default 'PENDING' check (status in ('PENDING', 'APPROVED', 'REJECTED')),
    note        text,
    uploaded_at timestamptz not null default now(),
    reviewed_at timestamptz,
    reviewed_by uuid references public.profiles(user_id)
);

create table public.refund_requests (
    refund_id  bigint generated always as identity primary key,
    order_id   bigint not null references public.orders(order_id) on delete cascade,
    buyer_id   uuid not null references public.profiles(user_id),
    reason     text not null check (length(reason) between 3 and 500),
    amount     numeric(12, 2) not null,
    status     text not null default 'REQUESTED' check (status in ('REQUESTED', 'APPROVED', 'REJECTED')),
    note       text,
    created_at timestamptz not null default now(),
    decided_at timestamptz,
    decided_by uuid references public.profiles(user_id)
);
create unique index ux_refund_open on public.refund_requests (order_id) where status in ('REQUESTED', 'APPROVED');

do $$
declare t text;
begin
    foreach t in array array['profiles', 'shops', 'categories', 'products', 'cart_items', 'campaigns', 'campaign_products',
                             'coupons', 'orders', 'order_items', 'coupon_redemptions', 'shipment_events', 'stock_movements',
                             'payment_slips', 'refund_requests'] loop
        execute format('alter table public.%I enable row level security', t);
        execute format('revoke all on public.%I from anon, authenticated', t);
        execute format('grant select, insert, update, delete on public.%I to service_role', t);  -- scripts and test clean-up
    end loop;
end $$;

-- ---------------------------------------------------------------- sign-up only through the API
create function public.shop_before_signup() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
    if coalesce(new.raw_app_meta_data ->> 'via', '') <> 'api'
       or coalesce(new.raw_app_meta_data ->> 'role', '') not in ('buyer', 'seller', 'admin') then
        raise exception 'Please register on the shop website' using errcode = '42501';
    end if;
    return new;
end $$;
create trigger shop_before_signup before insert on auth.users for each row execute function public.shop_before_signup();

create function public.shop_after_signup() returns trigger
language plpgsql security definer set search_path = '' as $$
declare role text := new.raw_app_meta_data ->> 'role';
begin
    insert into public.profiles (user_id, email, display_name, role)
    values (new.id, lower(new.email), coalesce(nullif(trim(new.raw_user_meta_data ->> 'display_name'), ''), split_part(new.email, '@', 1)), role);
    if role = 'seller' then
        insert into public.shops (owner_id, name, description)
        values (new.id, coalesce(nullif(trim(new.raw_user_meta_data ->> 'shop_name'), ''), split_part(new.email, '@', 1) || ' shop'),
                nullif(trim(new.raw_user_meta_data ->> 'shop_description'), ''));
    end if;
    return new;
end $$;
create trigger shop_after_signup after insert on auth.users for each row execute function public.shop_after_signup();

-- ---------------------------------------------------------------- internal helpers
create function public.me() returns public.profiles
language plpgsql stable security definer set search_path = '' as $$
declare p public.profiles;
begin
    select * into p from public.profiles where user_id = auth.uid();
    if not found then
        raise exception 'Sign in required' using errcode = '28000';
    end if;
    if p.status = 'banned' then
        raise exception 'This account is suspended' using errcode = '42501';
    end if;
    return p;
end $$;

create function public.require_role(p_role text) returns public.profiles
language plpgsql stable security definer set search_path = '' as $$
declare p public.profiles := public.me();
begin
    if p.role <> p_role then
        raise exception 'This is for % accounts', p_role || 's' using errcode = '42501';
    end if;
    return p;
end $$;

create function public.my_shop_id() returns bigint
language plpgsql stable security definer set search_path = '' as $$
declare v bigint;
begin
    perform public.require_role('seller');
    select shop_id into v from public.shops where owner_id = auth.uid();
    return v;
end $$;

-- Products a buyer can see: active, in a shop whose owner is not banned.
create function public.product_visible(p_product_id bigint) returns boolean
language sql stable security definer set search_path = '' as $$
    select exists (select 1 from public.products p join public.shops s on s.shop_id = p.shop_id
                     join public.profiles o on o.user_id = s.owner_id
                    where p.product_id = p_product_id and p.is_active and o.status = 'active')
$$;

create function public.move_stock(p_product_id bigint, p_change integer, p_reason text, p_order_id bigint, p_note text) returns void
language plpgsql volatile security definer set search_path = '' as $$
begin
    update public.products set stock_qty = stock_qty + p_change where product_id = p_product_id;
    insert into public.stock_movements (product_id, qty_change, reason, order_id, note, created_by)
    values (p_product_id, p_change, p_reason, p_order_id, p_note, auth.uid());
end $$;

create function public.order_event(p_order_id bigint, p_status text, p_note text) returns void
language sql volatile security definer set search_path = '' as $$
    insert into public.shipment_events (order_id, status, note, created_by) values (p_order_id, p_status, p_note, auth.uid())
$$;

-- Coupon check for one buyer and one shop subtotal. Returns {ok, discount, message, coupon_id, platform}.
create function public.coupon_check(p_code text, p_user uuid, p_shop_id bigint, p_subtotal numeric, p_lock boolean default false)
returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare
    c     public.coupons;
    used  integer;
    mine  integer;
    d     numeric;
begin
    if p_code is null or trim(p_code) = '' then
        return jsonb_build_object('ok', true, 'discount', 0);
    end if;
    if p_lock then
        select * into c from public.coupons where code = upper(trim(p_code)) for update;  -- serialises the usage limit
    else
        select * into c from public.coupons where code = upper(trim(p_code));
    end if;
    if not found or not c.is_active then
        return jsonb_build_object('ok', false, 'message', 'This coupon code does not exist');
    end if;
    if c.shop_id is not null and c.shop_id <> p_shop_id then
        return jsonb_build_object('ok', false, 'message', 'This coupon is for another shop');
    end if;
    if now() < c.starts_at then
        return jsonb_build_object('ok', false, 'message', 'This coupon is not active yet');
    end if;
    if now() >= c.expires_at then
        return jsonb_build_object('ok', false, 'message', 'This coupon has expired');
    end if;
    if p_subtotal < c.min_order_amount then
        return jsonb_build_object('ok', false, 'message', format('Spend at least THB %s to use this coupon', c.min_order_amount));
    end if;
    select count(*), count(*) filter (where user_id = p_user) into used, mine from public.coupon_redemptions where coupon_id = c.coupon_id;
    if c.usage_limit_total is not null and used >= c.usage_limit_total then
        return jsonb_build_object('ok', false, 'message', 'This coupon has been fully used');
    end if;
    if mine >= c.usage_limit_per_user then
        return jsonb_build_object('ok', false, 'message', 'You have already used this coupon');
    end if;
    d := case when c.discount_type = 'PERCENT' then round(p_subtotal * c.discount_value / 100, 2) else c.discount_value end;
    if c.max_discount is not null then d := least(d, c.max_discount); end if;
    d := least(d, p_subtotal);
    return jsonb_build_object('ok', true, 'discount', d, 'coupon_id', c.coupon_id, 'code', c.code,
                              'platform', c.shop_id is null, 'message', 'Coupon applied');
end $$;

-- Price a buyer's cart for one shop (+ optional coupon). The one place order money is computed.
create function public.price_cart(p_user uuid, p_shop_id bigint, p_coupon text, p_lock boolean default false) returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare
    v_items jsonb;
    v_sub   numeric;
    v_cpn   jsonb;
    v_disc  numeric;
    v_ship  numeric;
begin
    select jsonb_agg(jsonb_build_object('product_id', p.product_id, 'name', p.name, 'unit_price', p.price, 'qty', ci.qty,
                                        'line_total', round(p.price * ci.qty, 2), 'stock_qty', p.stock_qty,
                                        'available', public.product_visible(p.product_id) and p.stock_qty >= ci.qty)
                     order by ci.added_at, p.product_id),
           sum(round(p.price * ci.qty, 2))
      into v_items, v_sub
      from public.cart_items ci join public.products p on p.product_id = ci.product_id
     where ci.user_id = p_user and p.shop_id = p_shop_id;
    if v_items is null then
        raise exception 'Your cart has nothing from this shop' using errcode = '22023';
    end if;
    v_cpn := public.coupon_check(p_coupon, p_user, p_shop_id, v_sub, p_lock);
    v_disc := case when (v_cpn ->> 'ok')::boolean then coalesce((v_cpn ->> 'discount')::numeric, 0) else 0 end;
    v_ship := case when v_sub - v_disc >= 500 then 0 else 40 end;
    return jsonb_build_object('shop_id', p_shop_id, 'shop', (select name from public.shops where shop_id = p_shop_id),
                              'items', v_items, 'subtotal', v_sub, 'coupon', v_cpn, 'discount', v_disc,
                              'shipping_fee', v_ship, 'total', v_sub - v_disc + v_ship);
end $$;

create function public.next_order_number() returns text
language plpgsql volatile security definer set search_path = '' as $$
declare
    d    text := to_char(now() at time zone 'Asia/Bangkok', 'YYMMDD');
    last integer;
begin
    perform pg_advisory_xact_lock(hashtext('shop_order_number'));
    select max(substr(order_number, 9)::integer) into last from public.orders where order_number like 'OD' || d || '%';
    return 'OD' || d || lpad((coalesce(last, 0) + 1)::text, 5, '0');
end $$;

-- Can the caller see this order? buyer = own, seller = own shop, admin = all.
create function public.order_role(p_order public.orders) returns text
language plpgsql stable security definer set search_path = '' as $$
declare p public.profiles := public.me();
begin
    if p.role = 'admin' then return 'admin'; end if;
    if p.role = 'buyer' and p_order.buyer_id = p.user_id then return 'buyer'; end if;
    if p.role = 'seller' and exists (select 1 from public.shops s where s.shop_id = p_order.shop_id and s.owner_id = p.user_id) then
        return 'seller';
    end if;
    return null;
end $$;

create function public.order_json(p_order_id bigint) returns jsonb
language sql stable security definer set search_path = '' as $$
    select to_jsonb(o) || jsonb_build_object(
        'shop', (select jsonb_build_object('shop_id', s.shop_id, 'name', s.name) from public.shops s where s.shop_id = o.shop_id),
        'buyer', (select jsonb_build_object('display_name', b.display_name) from public.profiles b where b.user_id = o.buyer_id),
        'items', (select jsonb_agg(to_jsonb(i) order by i.line_no) from public.order_items i where i.order_id = o.order_id),
        'events', (select jsonb_agg(jsonb_build_object('status', e.status, 'note', e.note, 'at', e.created_at) order by e.event_id)
                     from public.shipment_events e where e.order_id = o.order_id),
        'slips', coalesce((select jsonb_agg(jsonb_build_object('slip_id', ps.slip_id, 'trans_ref', ps.trans_ref, 'amount', ps.amount,
                                                               'slip_path', ps.slip_path, 'status', ps.status, 'note', ps.note,
                                                               'uploaded_at', ps.uploaded_at) order by ps.slip_id)
                             from public.payment_slips ps where ps.order_id = o.order_id), '[]'::jsonb),
        'refunds', coalesce((select jsonb_agg(to_jsonb(r) - 'buyer_id' - 'decided_by' order by r.refund_id)
                               from public.refund_requests r where r.order_id = o.order_id), '[]'::jsonb))
      from public.orders o where o.order_id = p_order_id
$$;

-- ---------------------------------------------------------------- public catalogue (no sign-in needed)
create function public.catalog(p_q text default null, p_category_id integer default null, p_shop_id bigint default null,
                               p_sort text default 'new', p_limit integer default 24, p_offset integer default 0) returns jsonb
language plpgsql stable security definer set search_path = '' as $$
begin
    if p_sort not in ('new', 'price_asc', 'price_desc', 'popular') then
        raise exception 'Unknown sort' using errcode = '22023';
    end if;
    return (
    with sel as (
        select p.product_id, p.name, p.price, p.image_url, p.stock_qty, p.category_id, c.name category, s.shop_id, s.name shop,
               p.created_at, coalesce((select sum(i.qty) from public.order_items i join public.orders o on o.order_id = i.order_id
                                        where i.product_id = p.product_id and o.status not in ('CANCELLED', 'REFUNDED', 'PENDING_PAYMENT')), 0) sold
          from public.products p join public.shops s on s.shop_id = p.shop_id
          join public.profiles ow on ow.user_id = s.owner_id
          left join public.categories c on c.category_id = p.category_id
         where p.is_active and ow.status = 'active'
           and (p_category_id is null or p.category_id = p_category_id)
           and (p_shop_id is null or p.shop_id = p_shop_id)
           and (p_q is null or p.name ilike '%' || p_q || '%' or s.name ilike '%' || p_q || '%'))
    select jsonb_build_object(
        'total', (select count(*) from sel),
        'categories', (select jsonb_agg(jsonb_build_object('category_id', category_id, 'name', name) order by name) from public.categories),
        'items', coalesce((select jsonb_agg(to_jsonb(x)) from (
                    select * from sel order by
                        case when p_sort = 'price_asc' then price end asc, case when p_sort = 'price_desc' then price end desc,
                        case when p_sort = 'popular' then sold end desc, created_at desc, product_id desc
                    limit least(greatest(p_limit, 1), 100) offset greatest(p_offset, 0)) x), '[]'::jsonb)));
end $$;

create function public.product_page(p_product_id bigint) returns jsonb
language plpgsql stable security definer set search_path = '' as $$
begin
    if not public.product_visible(p_product_id) then
        raise exception 'Product not found' using errcode = 'PT404';
    end if;
    return (select to_jsonb(p) - 'low_stock_threshold' || jsonb_build_object(
                'shop', jsonb_build_object('shop_id', s.shop_id, 'name', s.name, 'description', s.description),
                'category', (select name from public.categories c where c.category_id = p.category_id),
                'shop_coupons', coalesce((select jsonb_agg(jsonb_build_object('code', k.code, 'discount_type', k.discount_type,
                                                                              'discount_value', k.discount_value, 'min_order_amount', k.min_order_amount,
                                                                              'max_discount', k.max_discount, 'expires_at', k.expires_at))
                                            from public.coupons k where k.shop_id = s.shop_id and k.is_active
                                             and now() between k.starts_at and k.expires_at), '[]'::jsonb))
              from public.products p join public.shops s on s.shop_id = p.shop_id where p.product_id = p_product_id);
end $$;

create function public.campaigns_live() returns jsonb
language sql stable security definer set search_path = '' as $$
    select coalesce(jsonb_agg(jsonb_build_object(
               'campaign_id', c.campaign_id, 'name', c.name, 'description', c.description, 'ends_at', c.ends_at,
               'coupons', (select coalesce(jsonb_agg(jsonb_build_object('code', k.code, 'discount_type', k.discount_type,
                                                                       'discount_value', k.discount_value, 'min_order_amount', k.min_order_amount,
                                                                       'max_discount', k.max_discount)), '[]'::jsonb)
                             from public.coupons k where k.campaign_id = c.campaign_id and k.is_active and now() < k.expires_at),
               'products', (select coalesce(jsonb_agg(jsonb_build_object('product_id', p.product_id, 'name', p.name, 'price', p.price,
                                                                        'image_url', p.image_url, 'shop', s.name)), '[]'::jsonb)
                              from public.campaign_products cp join public.products p on p.product_id = cp.product_id
                              join public.shops s on s.shop_id = p.shop_id
                             where cp.campaign_id = c.campaign_id and public.product_visible(p.product_id)))
           order by c.ends_at), '[]'::jsonb)
      from public.campaigns c where now() between c.starts_at and c.ends_at
$$;

-- ---------------------------------------------------------------- everyone signed in
create function public.my_account() returns jsonb
language plpgsql stable security definer set search_path = '' as $$
declare p public.profiles;
begin
    select * into p from public.profiles where user_id = auth.uid();
    if not found then
        return null;
    end if;
    return jsonb_build_object('user_id', p.user_id, 'email', p.email, 'display_name', p.display_name, 'role', p.role,
                              'status', p.status, 'shop', (select jsonb_build_object('shop_id', s.shop_id, 'name', s.name)
                                                            from public.shops s where s.owner_id = p.user_id));
end $$;

create function public.order_get(p_order_id bigint) returns jsonb
language plpgsql stable security definer set search_path = '' as $$
declare
    o public.orders;
    r text;
begin
    select * into o from public.orders where order_id = p_order_id;
    r := case when found then public.order_role(o) end;
    if r is null then
        raise exception 'Order not found' using errcode = 'PT404';  -- not yours: no hint that it exists
    end if;
    return public.order_json(p_order_id) || jsonb_build_object('viewer', r);
end $$;

-- ---------------------------------------------------------------- buyer
create function public.cart_set(p_product_id bigint, p_qty integer) returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare p public.profiles := public.require_role('buyer');
begin
    if coalesce(p_qty, 0) <= 0 then
        delete from public.cart_items where user_id = p.user_id and product_id = p_product_id;
    else
        if not public.product_visible(p_product_id) then
            raise exception 'Product not found' using errcode = 'PT404';
        end if;
        if p_qty > 99 then
            raise exception 'At most 99 of one product' using errcode = '22023';
        end if;
        insert into public.cart_items (user_id, product_id, qty) values (p.user_id, p_product_id, p_qty)
        on conflict (user_id, product_id) do update set qty = excluded.qty;
    end if;
    return public.cart_get();
end $$;

create function public.cart_get() returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare p public.profiles := public.require_role('buyer');
begin
    return coalesce((select jsonb_agg(public.price_cart(p.user_id, x.shop_id, null) order by x.shop_id)
                       from (select distinct pr.shop_id from public.cart_items ci join public.products pr on pr.product_id = ci.product_id
                              where ci.user_id = p.user_id) x), '[]'::jsonb);
end $$;

create function public.checkout_quote(p_shop_id bigint, p_coupon text default null) returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare p public.profiles := public.require_role('buyer');
begin
    return public.price_cart(p.user_id, p_shop_id, p_coupon);
end $$;

-- One shop's cart -> one order, atomically: coupon locked and redeemed, stock decremented (never below 0).
create function public.checkout(p_shop_id bigint, p_coupon text, p_ship_name text, p_ship_phone text, p_ship_address text) returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare
    p    public.profiles := public.require_role('buyer');
    q    jsonb;
    it   jsonb;
    v_id bigint;
    n    integer := 0;
begin
    if coalesce(trim(p_ship_name), '') = '' or coalesce(trim(p_ship_phone), '') = '' or length(coalesce(trim(p_ship_address), '')) < 10 then
        raise exception 'Please fill in the name, phone and full delivery address' using errcode = '22023';
    end if;
    q := public.price_cart(p.user_id, p_shop_id, p_coupon, true);
    if p_coupon is not null and trim(p_coupon) <> '' and not (q -> 'coupon' ->> 'ok')::boolean then
        raise exception '%', q -> 'coupon' ->> 'message' using errcode = '22023';
    end if;
    insert into public.orders (order_number, buyer_id, shop_id, status, subtotal, discount, shipping_fee, total, coupon_id, coupon_code,
                               platform_funded, ship_name, ship_phone, ship_address, pay_by)
    values (public.next_order_number(), p.user_id, p_shop_id, 'PENDING_PAYMENT', (q ->> 'subtotal')::numeric, (q ->> 'discount')::numeric,
            (q ->> 'shipping_fee')::numeric, (q ->> 'total')::numeric, (q -> 'coupon' ->> 'coupon_id')::bigint, q -> 'coupon' ->> 'code',
            coalesce((q -> 'coupon' ->> 'platform')::boolean, false), trim(p_ship_name), trim(p_ship_phone), trim(p_ship_address),
            now() + interval '24 hours')
    returning order_id into v_id;
    for it in select * from jsonb_array_elements(q -> 'items') loop
        n := n + 1;
        if not public.product_visible((it ->> 'product_id')::bigint) then
            raise exception '% is no longer for sale', it ->> 'name' using errcode = '22023';
        end if;
        update public.products set stock_qty = stock_qty - (it ->> 'qty')::integer
         where product_id = (it ->> 'product_id')::bigint and stock_qty >= (it ->> 'qty')::integer;
        if not found then
            raise exception 'Not enough stock for %', it ->> 'name' using errcode = 'PT409';
        end if;
        insert into public.stock_movements (product_id, qty_change, reason, order_id, created_by)
        values ((it ->> 'product_id')::bigint, -(it ->> 'qty')::integer, 'SALE', v_id, p.user_id);
        insert into public.order_items (order_id, line_no, product_id, name, unit_price, qty, line_total)
        values (v_id, n, (it ->> 'product_id')::bigint, it ->> 'name', (it ->> 'unit_price')::numeric, (it ->> 'qty')::integer,
                (it ->> 'line_total')::numeric);
    end loop;
    if (q ->> 'discount')::numeric > 0 then
        insert into public.coupon_redemptions (coupon_id, user_id, order_id, discount_amount)
        values ((q -> 'coupon' ->> 'coupon_id')::bigint, p.user_id, v_id, (q ->> 'discount')::numeric);
    end if;
    delete from public.cart_items ci using public.products pr
     where ci.product_id = pr.product_id and ci.user_id = p.user_id and pr.shop_id = p_shop_id;
    perform public.order_event(v_id, 'PENDING_PAYMENT', 'Order placed. Please pay within 24 hours.');
    return public.order_json(v_id);
end $$;

create function public.my_orders(p_status text default null) returns jsonb
language plpgsql stable security definer set search_path = '' as $$
declare p public.profiles := public.require_role('buyer');
begin
    return coalesce((select jsonb_agg(jsonb_build_object('order_id', o.order_id, 'order_number', o.order_number, 'status', o.status,
                                                         'total', o.total, 'created_at', o.created_at, 'shop', s.name,
                                                         'items', (select count(*) from public.order_items i where i.order_id = o.order_id),
                                                         'tracking_number', o.tracking_number) order by o.order_id desc)
                       from public.orders o join public.shops s on s.shop_id = o.shop_id
                      where o.buyer_id = p.user_id and (p_status is null or o.status = p_status)), '[]'::jsonb);
end $$;

create function public.release_order(p_order public.orders, p_reason text, p_status text) returns void
language plpgsql volatile security definer set search_path = '' as $$
declare i record;
begin
    for i in select product_id, qty from public.order_items where order_id = p_order.order_id loop
        perform public.move_stock(i.product_id, i.qty, case when p_status = 'REFUNDED' then 'REFUND' else 'CANCEL' end, p_order.order_id, p_reason);
    end loop;
end $$;

-- Buyer (own order) or seller (own shop) cancels an UNPAID order: stock back, coupon use released.
create function public.order_cancel(p_order_id bigint, p_reason text) returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare
    o public.orders;
    r text;
begin
    select * into o from public.orders where order_id = p_order_id for update;
    r := case when found then public.order_role(o) end;
    if r is null or r = 'admin' then
        raise exception 'Order not found' using errcode = 'PT404';
    end if;
    if o.status <> 'PENDING_PAYMENT' then
        raise exception 'Only unpaid orders can be cancelled; ask for a refund instead' using errcode = 'PT409';
    end if;
    update public.orders set status = 'CANCELLED', cancelled_at = now(), cancel_reason = left(coalesce(p_reason, 'Cancelled'), 200)
     where order_id = o.order_id;
    perform public.release_order(o, 'Order cancelled', 'CANCELLED');
    delete from public.coupon_redemptions where order_id = o.order_id;
    update public.payment_slips set status = 'REJECTED', note = 'Order cancelled' where order_id = o.order_id and status = 'PENDING';
    perform public.order_event(o.order_id, 'CANCELLED', format('Cancelled by the %s: %s', r, coalesce(p_reason, '-')));
    return public.order_json(o.order_id);
end $$;

create function public.slip_submit(p_order_id bigint, p_trans_ref text, p_amount numeric, p_slip_path text) returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare
    p public.profiles := public.require_role('buyer');
    o public.orders;
begin
    select * into o from public.orders where order_id = p_order_id and buyer_id = p.user_id for update;
    if not found then
        raise exception 'Order not found' using errcode = 'PT404';
    end if;
    if o.status <> 'PENDING_PAYMENT' then
        raise exception 'This order is not waiting for payment' using errcode = 'PT409';
    end if;
    if p_slip_path is null or p_slip_path not like p.user_id::text || '/' || o.order_id::text || '/%' then
        raise exception 'Upload the slip for this order first' using errcode = '22023';
    end if;
    if exists (select 1 from public.payment_slips where trans_ref = upper(trim(p_trans_ref))) then
        raise exception 'This transfer reference has already been used' using errcode = 'PT409';
    end if;
    insert into public.payment_slips (order_id, trans_ref, amount, slip_path) values (o.order_id, upper(trim(p_trans_ref)), round(p_amount, 2), p_slip_path);
    perform public.order_event(o.order_id, 'PENDING_PAYMENT', 'Transfer slip uploaded; waiting for the seller to check it.');
    return public.order_json(o.order_id);
end $$;

create function public.refund_request(p_order_id bigint, p_reason text) returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare
    p public.profiles := public.require_role('buyer');
    o public.orders;
begin
    select * into o from public.orders where order_id = p_order_id and buyer_id = p.user_id for update;
    if not found then
        raise exception 'Order not found' using errcode = 'PT404';
    end if;
    if o.status not in ('TO_SHIP', 'SHIPPED', 'DELIVERED') then
        raise exception 'Only paid orders can be refunded' using errcode = 'PT409';
    end if;
    if exists (select 1 from public.refund_requests where order_id = o.order_id and status in ('REQUESTED', 'APPROVED')) then
        raise exception 'A refund request is already open for this order' using errcode = 'PT409';
    end if;
    insert into public.refund_requests (order_id, buyer_id, reason, amount) values (o.order_id, p.user_id, trim(p_reason), o.total);
    perform public.order_event(o.order_id, o.status, 'Refund requested: ' || left(trim(p_reason), 200));
    return public.order_json(o.order_id);
end $$;

create function public.order_received(p_order_id bigint) returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare
    o public.orders;
    r text;
begin
    select * into o from public.orders where order_id = p_order_id for update;
    r := case when found then public.order_role(o) end;
    if r not in ('buyer', 'seller') or r is null then
        raise exception 'Order not found' using errcode = 'PT404';
    end if;
    if o.status <> 'SHIPPED' then
        raise exception 'Only shipped orders can be marked as delivered' using errcode = 'PT409';
    end if;
    update public.orders set status = 'DELIVERED', delivered_at = now() where order_id = o.order_id;
    perform public.order_event(o.order_id, 'DELIVERED', case when r = 'buyer' then 'Received by the buyer' else 'Delivered (seller update)' end);
    return public.order_json(o.order_id);
end $$;

-- ---------------------------------------------------------------- seller
create function public.seller_overview() returns jsonb
language plpgsql stable security definer set search_path = '' as $$
declare s bigint := public.my_shop_id();
begin
    return jsonb_build_object(
        'shop', (select to_jsonb(x) from public.shops x where x.shop_id = s),
        'orders_by_status', coalesce((select jsonb_object_agg(status, n) from (select status, count(*) n from public.orders where shop_id = s group by 1) x), '{}'::jsonb),
        'sales_30d', (select coalesce(sum(subtotal - case when platform_funded then 0 else discount end), 0) from public.orders
                       where shop_id = s and status in ('TO_SHIP', 'SHIPPED', 'DELIVERED') and paid_at > now() - interval '30 days'),
        'slips_to_check', (select count(*) from public.payment_slips ps join public.orders o on o.order_id = ps.order_id
                            where o.shop_id = s and ps.status = 'PENDING'),
        'refunds_to_decide', (select count(*) from public.refund_requests rr join public.orders o on o.order_id = rr.order_id
                               where o.shop_id = s and rr.status = 'REQUESTED'),
        'low_stock', coalesce((select jsonb_agg(jsonb_build_object('product_id', product_id, 'name', name, 'stock_qty', stock_qty,
                                                                  'low_stock_threshold', low_stock_threshold) order by stock_qty)
                                 from public.products where shop_id = s and is_active and stock_qty <= low_stock_threshold), '[]'::jsonb));
end $$;

create function public.seller_products() returns jsonb
language plpgsql stable security definer set search_path = '' as $$
declare s bigint := public.my_shop_id();
begin
    return coalesce((select jsonb_agg(to_jsonb(p) || jsonb_build_object(
                         'category', (select name from public.categories c where c.category_id = p.category_id),
                         'low', p.stock_qty <= p.low_stock_threshold,
                         'sold', coalesce((select sum(i.qty) from public.order_items i join public.orders o on o.order_id = i.order_id
                                            where i.product_id = p.product_id and o.status in ('TO_SHIP', 'SHIPPED', 'DELIVERED')), 0),
                         'revenue', coalesce((select sum(i.line_total) from public.order_items i join public.orders o on o.order_id = i.order_id
                                               where i.product_id = p.product_id and o.status in ('TO_SHIP', 'SHIPPED', 'DELIVERED')), 0))
                       order by p.product_id desc)
                       from public.products p where p.shop_id = s), '[]'::jsonb);
end $$;

create function public.seller_product_save(p_product_id bigint, p_name text, p_description text, p_category_id integer,
                                           p_price numeric, p_image_url text, p_low_stock_threshold integer, p_is_active boolean,
                                           p_initial_stock integer default 0) returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare
    s    bigint := public.my_shop_id();
    v_id bigint;
begin
    if p_price is null or p_price <= 0 or p_price <> round(p_price, 2) then
        raise exception 'Price must be more than 0 with at most 2 decimals' using errcode = '22023';
    end if;
    if p_image_url is not null and p_image_url !~ '^https://' then
        raise exception 'The image must be an https:// link' using errcode = '22023';
    end if;
    if p_product_id is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, low_stock_threshold, is_active)
        values (s, trim(p_name), nullif(trim(p_description), ''), p_category_id, p_price, p_image_url, coalesce(p_low_stock_threshold, 5),
                coalesce(p_is_active, true))
        returning product_id into v_id;
        if coalesce(p_initial_stock, 0) > 0 then
            perform public.move_stock(v_id, p_initial_stock, 'INITIAL', null, 'Opening stock');
        end if;
    else
        update public.products set name = trim(p_name), description = nullif(trim(p_description), ''), category_id = p_category_id,
                                   price = p_price, image_url = p_image_url, low_stock_threshold = coalesce(p_low_stock_threshold, low_stock_threshold),
                                   is_active = coalesce(p_is_active, is_active)
         where product_id = p_product_id and shop_id = s
        returning product_id into v_id;
        if v_id is null then
            raise exception 'Product not found' using errcode = 'PT404';
        end if;
    end if;
    return (select to_jsonb(p) from public.products p where p.product_id = v_id);
end $$;

create function public.seller_stock_adjust(p_product_id bigint, p_change integer, p_reason text, p_note text default null) returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare
    s public.products;
begin
    select * into s from public.products where product_id = p_product_id and shop_id = public.my_shop_id() for update;
    if not found then
        raise exception 'Product not found' using errcode = 'PT404';
    end if;
    if p_reason not in ('RESTOCK', 'ADJUST') or coalesce(p_change, 0) = 0 or (p_reason = 'RESTOCK' and p_change < 0) then
        raise exception 'Use RESTOCK with a positive quantity, or ADJUST with a non-zero quantity' using errcode = '22023';
    end if;
    if s.stock_qty + p_change < 0 then
        raise exception 'Stock cannot go below 0 (now %)', s.stock_qty using errcode = '22023';
    end if;
    perform public.move_stock(p_product_id, p_change, p_reason, null, p_note);
    return jsonb_build_object('product_id', p_product_id, 'stock_qty', s.stock_qty + p_change,
                              'movements', (select jsonb_agg(to_jsonb(m) order by m.movement_id desc) from (
                                  select * from public.stock_movements where product_id = p_product_id order by movement_id desc limit 20) m));
end $$;

create function public.seller_stock_movements(p_product_id bigint) returns jsonb
language plpgsql stable security definer set search_path = '' as $$
begin
    if not exists (select 1 from public.products where product_id = p_product_id and shop_id = public.my_shop_id()) then
        raise exception 'Product not found' using errcode = 'PT404';
    end if;
    return coalesce((select jsonb_agg(to_jsonb(m) order by m.movement_id desc) from (
               select * from public.stock_movements where product_id = p_product_id order by movement_id desc limit 100) m), '[]'::jsonb);
end $$;

create function public.seller_orders(p_status text default null) returns jsonb
language plpgsql stable security definer set search_path = '' as $$
declare s bigint := public.my_shop_id();
begin
    return coalesce((select jsonb_agg(jsonb_build_object('order_id', o.order_id, 'order_number', o.order_number, 'status', o.status,
                                                         'total', o.total, 'created_at', o.created_at, 'buyer', b.display_name,
                                                         'items', (select count(*) from public.order_items i where i.order_id = o.order_id),
                                                         'slip_pending', exists (select 1 from public.payment_slips ps where ps.order_id = o.order_id and ps.status = 'PENDING'),
                                                         'refund_requested', exists (select 1 from public.refund_requests r where r.order_id = o.order_id and r.status = 'REQUESTED'))
                                      order by o.order_id desc)
                       from public.orders o join public.profiles b on b.user_id = o.buyer_id
                      where o.shop_id = s and (p_status is null or o.status = p_status)), '[]'::jsonb);
end $$;

create function public.slip_review(p_slip_id bigint, p_approve boolean, p_note text default null) returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare
    s  bigint := public.my_shop_id();
    ps public.payment_slips;
    o  public.orders;
begin
    select * into ps from public.payment_slips where slip_id = p_slip_id for update;
    select * into o from public.orders where order_id = ps.order_id and shop_id = s for update;
    if ps.slip_id is null or o.order_id is null then
        raise exception 'Slip not found' using errcode = 'PT404';
    end if;
    if ps.status <> 'PENDING' or o.status <> 'PENDING_PAYMENT' then
        raise exception 'This slip has already been checked' using errcode = 'PT409';
    end if;
    if p_approve and ps.amount <> o.total then
        raise exception 'The slip amount % does not match the order total %', ps.amount, o.total using errcode = '22023';
    end if;
    update public.payment_slips set status = case when p_approve then 'APPROVED' else 'REJECTED' end, note = p_note,
                                    reviewed_at = now(), reviewed_by = auth.uid() where slip_id = ps.slip_id;
    if p_approve then
        update public.orders set status = 'TO_SHIP', paid_at = now() where order_id = o.order_id;
        perform public.order_event(o.order_id, 'TO_SHIP', 'Payment confirmed. The seller is preparing your order.');
    else
        perform public.order_event(o.order_id, 'PENDING_PAYMENT', 'Slip rejected: ' || coalesce(p_note, 'please upload a correct slip'));
    end if;
    return public.order_json(o.order_id);
end $$;

create function public.order_ship(p_order_id bigint, p_carrier text, p_tracking text) returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare o public.orders;
begin
    select * into o from public.orders where order_id = p_order_id and shop_id = public.my_shop_id() for update;
    if not found then
        raise exception 'Order not found' using errcode = 'PT404';
    end if;
    if o.status <> 'TO_SHIP' then
        raise exception 'Only paid orders waiting to ship can be shipped' using errcode = 'PT409';
    end if;
    if exists (select 1 from public.refund_requests where order_id = o.order_id and status = 'REQUESTED') then
        raise exception 'Decide the open refund request first' using errcode = 'PT409';
    end if;
    if coalesce(trim(p_carrier), '') = '' or coalesce(trim(p_tracking), '') !~ '^[A-Za-z0-9-]{6,30}$' then
        raise exception 'Enter the carrier and a tracking number (6-30 letters, digits or -)' using errcode = '22023';
    end if;
    update public.orders set status = 'SHIPPED', shipped_at = now(), carrier = trim(p_carrier), tracking_number = upper(trim(p_tracking))
     where order_id = o.order_id;
    perform public.order_event(o.order_id, 'SHIPPED', format('Shipped with %s, tracking %s', trim(p_carrier), upper(trim(p_tracking))));
    return public.order_json(o.order_id);
end $$;

create function public.refund_decide(p_refund_id bigint, p_approve boolean, p_note text default null) returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare
    s  bigint := public.my_shop_id();
    rr public.refund_requests;
    o  public.orders;
begin
    select * into rr from public.refund_requests where refund_id = p_refund_id for update;
    select * into o from public.orders where order_id = rr.order_id and shop_id = s for update;
    if rr.refund_id is null or o.order_id is null then
        raise exception 'Refund request not found' using errcode = 'PT404';
    end if;
    if rr.status <> 'REQUESTED' then
        raise exception 'This refund request has already been decided' using errcode = 'PT409';
    end if;
    update public.refund_requests set status = case when p_approve then 'APPROVED' else 'REJECTED' end, note = p_note,
                                      decided_at = now(), decided_by = auth.uid() where refund_id = rr.refund_id;
    if p_approve then
        if o.status = 'TO_SHIP' then  -- never shipped: the goods are still here
            perform public.release_order(o, 'Refund before shipping', 'REFUNDED');
        end if;
        update public.orders set status = 'REFUNDED' where order_id = o.order_id;
        perform public.order_event(o.order_id, 'REFUNDED', 'Refund approved' || coalesce(': ' || p_note, ''));
    else
        perform public.order_event(o.order_id, o.status, 'Refund rejected' || coalesce(': ' || p_note, ''));
    end if;
    return public.order_json(o.order_id);
end $$;

-- Promotions = shop coupons.
create function public.seller_coupons() returns jsonb
language plpgsql stable security definer set search_path = '' as $$
declare s bigint := public.my_shop_id();
begin
    return coalesce((select jsonb_agg(to_jsonb(c) || jsonb_build_object('used', (select count(*) from public.coupon_redemptions r where r.coupon_id = c.coupon_id),
                                                                        'discount_given', (select coalesce(sum(discount_amount), 0) from public.coupon_redemptions r where r.coupon_id = c.coupon_id))
                                      order by c.coupon_id desc)
                       from public.coupons c where c.shop_id = s), '[]'::jsonb);
end $$;

create function public.coupon_save(p_code text, p_discount_type text, p_discount_value numeric, p_max_discount numeric,
                                   p_min_order_amount numeric, p_usage_limit_total integer, p_usage_limit_per_user integer,
                                   p_starts_at timestamptz, p_expires_at timestamptz, p_campaign_id bigint default null) returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare
    p    public.profiles := public.me();
    v_shop bigint;
    v_id bigint;
begin
    if p.role = 'seller' then
        v_shop := public.my_shop_id();
        if p_campaign_id is not null then
            raise exception 'Only the platform runs campaigns' using errcode = '42501';
        end if;
    elsif p.role <> 'admin' then
        raise exception 'Coupons are created by sellers (shop promotions) and admins (platform campaigns)' using errcode = '42501';
    end if;
    insert into public.coupons (code, shop_id, campaign_id, discount_type, discount_value, max_discount, min_order_amount,
                                usage_limit_total, usage_limit_per_user, starts_at, expires_at)
    values (upper(trim(p_code)), v_shop, p_campaign_id, p_discount_type, p_discount_value, p_max_discount, coalesce(p_min_order_amount, 0),
            p_usage_limit_total, coalesce(p_usage_limit_per_user, 1), coalesce(p_starts_at, now()), p_expires_at)
    returning coupon_id into v_id;
    return (select to_jsonb(c) from public.coupons c where c.coupon_id = v_id);
exception when unique_violation then
    raise exception 'This coupon code is already taken' using errcode = 'PT409';
when check_violation then
    raise exception 'Check the coupon values (code A-Z/0-9 3-20 chars, percent up to 90, expiry after start)' using errcode = '22023';
end $$;

create function public.coupon_set_active(p_coupon_id bigint, p_active boolean) returns void
language plpgsql volatile security definer set search_path = '' as $$
declare p public.profiles := public.me();
begin
    update public.coupons set is_active = p_active
     where coupon_id = p_coupon_id
       and ((p.role = 'admin' and shop_id is null) or (p.role = 'seller' and shop_id = (select shop_id from public.shops where owner_id = p.user_id)));
    if not found then
        raise exception 'Coupon not found' using errcode = 'PT404';
    end if;
end $$;

-- Seller accounting: per paid order the shop's revenue, platform fee 5 %, refunds, net payout; and a monthly summary.
create function public.seller_ledger(p_from date default null, p_to date default null) returns jsonb
language plpgsql stable security definer set search_path = '' as $$
declare s bigint := public.my_shop_id();
begin
    return (
    with l as (
        select o.order_id, o.order_number, (o.paid_at at time zone 'Asia/Bangkok')::date paid_on, o.status, o.subtotal,
               case when o.platform_funded then 0 else o.discount end shop_discount,
               case when o.platform_funded then o.discount else 0 end platform_discount,
               o.shipping_fee,
               round(0.05 * (o.subtotal - case when o.platform_funded then 0 else o.discount end), 2) platform_fee,
               case when o.status = 'REFUNDED' then o.total else 0 end refunded
          from public.orders o
         where o.shop_id = s and o.paid_at is not null
           and (p_from is null or (o.paid_at at time zone 'Asia/Bangkok')::date >= p_from)
           and (p_to is null or (o.paid_at at time zone 'Asia/Bangkok')::date <= p_to)),
    n as (select *, subtotal - shop_discount + shipping_fee - platform_fee - refunded net_payout from l)
    select jsonb_build_object(
        'platform_fee_pct', 5,
        'totals', (select jsonb_build_object('orders', count(*), 'gross_sales', coalesce(sum(subtotal), 0), 'shop_discounts', coalesce(sum(shop_discount), 0),
                                             'platform_discounts', coalesce(sum(platform_discount), 0), 'shipping', coalesce(sum(shipping_fee), 0),
                                             'platform_fees', coalesce(sum(platform_fee), 0), 'refunds', coalesce(sum(refunded), 0),
                                             'net_payout', coalesce(sum(net_payout), 0)) from n),
        'monthly', coalesce((select jsonb_agg(x order by x.month) from (
                        select to_char(paid_on, 'YYYY-MM') as month, count(*) orders, sum(subtotal) gross_sales, sum(shop_discount) shop_discounts,
                               sum(platform_fee) platform_fees, sum(refunded) refunds, sum(net_payout) net_payout
                          from n group by 1) x), '[]'::jsonb),
        'orders', coalesce((select jsonb_agg(to_jsonb(n) order by n.order_id desc) from n), '[]'::jsonb)));
end $$;

-- Seller customers: who buys, how often, how much; segment Frequent (3+ orders) / Repeat (2) / New (1).
create function public.seller_customers() returns jsonb
language plpgsql stable security definer set search_path = '' as $$
declare s bigint := public.my_shop_id();
begin
    return coalesce((select jsonb_agg(x order by x.spend desc) from (
        select b.display_name buyer, count(*) orders, sum(o.total) spend, max(o.created_at) last_order,
               case when count(*) >= 3 then 'Frequent' when count(*) = 2 then 'Repeat' else 'New' end segment,
               (select string_agg(distinct i.name, ', ') from public.order_items i join public.orders o2 on o2.order_id = i.order_id
                 where o2.buyer_id = b.user_id and o2.shop_id = s) products
          from public.orders o join public.profiles b on b.user_id = o.buyer_id
         where o.shop_id = s and o.status in ('TO_SHIP', 'SHIPPED', 'DELIVERED')
         group by b.user_id, b.display_name) x), '[]'::jsonb);
end $$;

-- ---------------------------------------------------------------- platform admin
create function public.admin_overview(p_days integer default 30) returns jsonb
language plpgsql stable security definer set search_path = '' as $$
begin
    perform public.require_role('admin');
    return jsonb_build_object(
        'users', (select jsonb_object_agg(role, n) from (select role, count(*) n from public.profiles group by 1) x),
        'banned', (select count(*) from public.profiles where status = 'banned'),
        'gmv', (select coalesce(sum(total), 0) from public.orders where status in ('TO_SHIP', 'SHIPPED', 'DELIVERED')
                 and paid_at > now() - make_interval(days => p_days)),
        'platform_fees', (select coalesce(sum(round(0.05 * (subtotal - case when platform_funded then 0 else discount end), 2)), 0)
                            from public.orders where status in ('TO_SHIP', 'SHIPPED', 'DELIVERED') and paid_at > now() - make_interval(days => p_days)),
        'top_shops', coalesce((select jsonb_agg(x order by x.sales desc) from (
                        select s.shop_id, s.name, ow.status owner_status, count(o.order_id) orders, coalesce(sum(o.subtotal), 0) sales,
                               count(distinct o.buyer_id) buyers
                          from public.shops s join public.profiles ow on ow.user_id = s.owner_id
                          left join public.orders o on o.shop_id = s.shop_id and o.status in ('TO_SHIP', 'SHIPPED', 'DELIVERED')
                                                   and o.paid_at > now() - make_interval(days => p_days)
                         group by 1, 2, 3 order by 5 desc limit 20) x), '[]'::jsonb));
end $$;

create function public.admin_users(p_q text default null) returns jsonb
language plpgsql stable security definer set search_path = '' as $$
begin
    perform public.require_role('admin');
    return coalesce((select jsonb_agg(jsonb_build_object('user_id', p.user_id, 'email', p.email, 'display_name', p.display_name, 'role', p.role,
                                                         'status', p.status, 'ban_reason', p.ban_reason, 'created_at', p.created_at,
                                                         'shop', (select name from public.shops s where s.owner_id = p.user_id),
                                                         'orders', (select count(*) from public.orders o where o.buyer_id = p.user_id))
                                      order by p.created_at desc)
                       from public.profiles p where p_q is null or p.email ilike '%' || p_q || '%' or p.display_name ilike '%' || p_q || '%'), '[]'::jsonb);
end $$;

-- Ban / unban in the database (every function refuses a banned user at once); the API also blocks sign-in in Supabase Auth.
create function public.admin_set_ban(p_user_id uuid, p_banned boolean, p_reason text default null) returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare me public.profiles := public.require_role('admin');
begin
    if p_user_id = me.user_id then
        raise exception 'You cannot ban yourself' using errcode = '22023';
    end if;
    if exists (select 1 from public.profiles where user_id = p_user_id and role = 'admin') then
        raise exception 'Admins cannot be banned here' using errcode = '42501';
    end if;
    if p_banned and coalesce(trim(p_reason), '') = '' then
        raise exception 'Give a reason for the ban' using errcode = '22023';
    end if;
    update public.profiles set status = case when p_banned then 'banned' else 'active' end,
                               ban_reason = case when p_banned then trim(p_reason) end
     where user_id = p_user_id;
    if not found then
        raise exception 'User not found' using errcode = 'PT404';
    end if;
    return (select jsonb_build_object('user_id', user_id, 'status', status, 'ban_reason', ban_reason) from public.profiles where user_id = p_user_id);
end $$;

create function public.admin_campaigns() returns jsonb
language plpgsql stable security definer set search_path = '' as $$
begin
    perform public.require_role('admin');
    return coalesce((select jsonb_agg(to_jsonb(c) || jsonb_build_object(
                         'coupons', (select coalesce(jsonb_agg(jsonb_build_object('coupon_id', k.coupon_id, 'code', k.code, 'is_active', k.is_active,
                                                                                 'used', (select count(*) from public.coupon_redemptions r where r.coupon_id = k.coupon_id),
                                                                                 'discount_given', (select coalesce(sum(discount_amount), 0) from public.coupon_redemptions r where r.coupon_id = k.coupon_id))), '[]'::jsonb)
                                       from public.coupons k where k.campaign_id = c.campaign_id),
                         'products', (select count(*) from public.campaign_products cp where cp.campaign_id = c.campaign_id))
                       order by c.starts_at desc) from public.campaigns c), '[]'::jsonb);
end $$;

create function public.admin_campaign_save(p_name text, p_description text, p_starts_at timestamptz, p_ends_at timestamptz,
                                           p_product_ids bigint[] default '{}') returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare
    me   public.profiles := public.require_role('admin');
    v_id bigint;
begin
    insert into public.campaigns (name, description, starts_at, ends_at, created_by)
    values (trim(p_name), nullif(trim(p_description), ''), p_starts_at, p_ends_at, me.user_id) returning campaign_id into v_id;
    insert into public.campaign_products (campaign_id, product_id)
    select v_id, x from unnest(coalesce(p_product_ids, '{}')) x where public.product_visible(x) on conflict do nothing;
    return (select to_jsonb(c) from public.campaigns c where c.campaign_id = v_id);
end $$;

-- Unpaid orders past pay_by: cancelled, stock back (daily cron with the service key).
create function public.cancel_expired_orders() returns integer
language plpgsql volatile security definer set search_path = '' as $$
declare
    o public.orders;
    n integer := 0;
begin
    for o in select * from public.orders where status = 'PENDING_PAYMENT' and pay_by < now()
              and not exists (select 1 from public.payment_slips ps where ps.order_id = orders.order_id and ps.status = 'PENDING')
              for update skip locked loop
        update public.orders set status = 'CANCELLED', cancelled_at = now(), cancel_reason = 'Not paid within 24 hours' where order_id = o.order_id;
        perform public.release_order(o, 'Payment time ran out', 'CANCELLED');
        delete from public.coupon_redemptions where order_id = o.order_id;
        insert into public.shipment_events (order_id, status, note) values (o.order_id, 'CANCELLED', 'Not paid within 24 hours');
        n := n + 1;
    end loop;
    return n;
end $$;

-- ---------------------------------------------------------------- grants
do $$
declare f record;
begin
    for f in select p.oid::regprocedure sig, p.proname from pg_proc p join pg_namespace n on n.oid = p.pronamespace
              where n.nspname = 'public' loop
        execute format('revoke all on function %s from public, anon, authenticated', f.sig);
        if f.proname in ('catalog', 'product_page', 'campaigns_live') then
            execute format('grant execute on function %s to anon, authenticated', f.sig);
        elsif f.proname in ('my_account', 'order_get', 'cart_set', 'cart_get', 'checkout_quote', 'checkout', 'my_orders', 'order_cancel',
                            'slip_submit', 'refund_request', 'order_received', 'seller_overview', 'seller_products', 'seller_product_save',
                            'seller_stock_adjust', 'seller_stock_movements', 'seller_orders', 'slip_review', 'order_ship', 'refund_decide',
                            'seller_coupons', 'coupon_save', 'coupon_set_active', 'seller_ledger', 'seller_customers', 'admin_overview',
                            'admin_users', 'admin_set_ban', 'admin_campaigns', 'admin_campaign_save') then
            execute format('grant execute on function %s to authenticated', f.sig);
        elsif f.proname = 'cancel_expired_orders' then
            execute format('grant execute on function %s to service_role', f.sig);
        end if;
    end loop;
end $$;

-- ---------------------------------------------------------------- storage: payment slips (private bucket)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('payment-slips', 'payment-slips', false, 5242880, array['image/jpeg', 'image/png', 'image/webp', 'application/pdf'])
on conflict (id) do nothing;

create function public.slip_object_visible(p_name text) returns boolean
language sql stable security definer set search_path = '' as $$
    select exists (select 1 from public.profiles p where p.user_id = auth.uid() and p.status = 'active'
                      and (split_part(p_name, '/', 1) = p.user_id::text
                           or exists (select 1 from public.orders o join public.shops s on s.shop_id = o.shop_id
                                       where o.order_id::text = split_part(p_name, '/', 2) and split_part(p_name, '/', 1) = o.buyer_id::text
                                         and s.owner_id = p.user_id)
                           or p.role = 'admin'))
$$;
create function public.slip_upload_allowed(p_name text) returns boolean
language sql stable security definer set search_path = '' as $$
    select exists (select 1 from public.orders o join public.profiles p on p.user_id = o.buyer_id
                    where p.user_id = auth.uid() and p.status = 'active' and o.status = 'PENDING_PAYMENT'
                      and split_part(p_name, '/', 1) = auth.uid()::text and split_part(p_name, '/', 2) = o.order_id::text)
$$;
revoke all on function public.slip_object_visible(text), public.slip_upload_allowed(text) from public, anon;
grant execute on function public.slip_object_visible(text), public.slip_upload_allowed(text) to authenticated;

-- Buyers upload into their own folder, for their own unpaid order; buyer, that order's seller and admins can read.
create policy slips_insert_own on storage.objects for insert to authenticated
    with check (bucket_id = 'payment-slips' and public.slip_upload_allowed(name));
create policy slips_read on storage.objects for select to authenticated
    using (bucket_id = 'payment-slips' and public.slip_object_visible(name));

commit;
