-- Upgrade FDE Shop for large multi-category catalog, faceted smart search, and Sales Concierge Bot.
-- Conventions (CLAUDE.md):
--   - Every callable function is `security definer set search_path = ''` and qualifies all names with `public.`.
--   - Users have no direct table grants; explicit EXECUTE grants are set at the end of this migration.
--   - Backward-compatible with existing API callers and tests/test_shop_live.py.

begin;

-- ---------------------------------------------------------------- schema extensions
alter table public.categories
    add column if not exists parent_id  integer references public.categories(category_id) on delete set null,
    add column if not exists slug       text,
    add column if not exists name_th    text,
    add column if not exists icon       text,
    add column if not exists sort_order integer not null default 100;

create unique index if not exists ux_categories_slug on public.categories (slug) where slug is not null;
create index if not exists ix_categories_parent on public.categories (parent_id);

alter table public.products
    add column if not exists brand    text,
    add column if not exists sku      text,
    add column if not exists barcode  text,
    add column if not exists unit     text not null default 'ชิ้น',
    add column if not exists pack_qty integer not null default 1,
    add column if not exists tags     text[] not null default '{}';

do $$
begin
    if not exists (select 1 from pg_constraint where conname = 'products_pack_qty_check') then
        alter table public.products add constraint products_pack_qty_check check (pack_qty >= 1 and pack_qty <= 10000);
    end if;
end $$;

create index if not exists ix_products_category on public.products (category_id);
create index if not exists ix_products_price on public.products (price);
create index if not exists ix_products_brand_lower on public.products (lower(brand)) where brand is not null;
create index if not exists ix_products_barcode on public.products (barcode) where barcode is not null;
create index if not exists ix_products_tags on public.products using gin (tags);

-- ---------------------------------------------------------------- drop old overloaded signatures cleanly
drop function if exists public.catalog(text, integer, bigint, text, integer, integer);
drop function if exists public.seller_product_save(bigint, text, text, integer, numeric, text, integer, boolean, integer);

-- ---------------------------------------------------------------- enhanced public catalog with facets & smart filters
create or replace function public.catalog(
    p_q           text     default null,
    p_category_id integer  default null,
    p_shop_id     bigint   default null,
    p_sort        text     default 'new',
    p_limit       integer  default 24,
    p_offset      integer  default 0,
    p_brand       text     default null,
    p_min_price   numeric  default null,
    p_max_price   numeric  default null,
    p_tags        text[]   default null,
    p_in_stock    boolean  default false,
    p_exclude     text[]   default null,
    p_terms       text[]   default null
) returns jsonb
language plpgsql stable security definer set search_path = '' as $$
declare
    v_q       text   := nullif(trim(coalesce(p_q, '')), '');
    v_brand   text   := nullif(trim(coalesce(p_brand, '')), '');
    v_tags    text[] := case when p_tags is not null and array_length(p_tags, 1) > 0 then p_tags else null end;
    v_exclude text[] := case when p_exclude is not null and array_length(p_exclude, 1) > 0 then p_exclude else null end;
    v_terms   text[] := case when p_terms is not null and array_length(p_terms, 1) > 0 then p_terms else null end;
begin
    if p_sort not in ('new', 'price_asc', 'price_desc', 'popular', 'unit_price_asc') then
        raise exception 'Unknown sort' using errcode = '22023';
    end if;

    return (
    with base as (
        select p.product_id,
               p.name,
               p.description,
               p.price,
               p.image_url,
               p.stock_qty,
               p.category_id,
               c.parent_id as parent_category_id,
               c.name as category,
               c.name_th as category_th,
               pc.name as parent_category,
               pc.name_th as parent_category_th,
               s.shop_id,
               s.name as shop,
               p.brand,
               p.sku,
               p.barcode,
               p.unit,
               p.pack_qty,
               round(p.price / greatest(p.pack_qty, 1), 2) as unit_price,
               p.tags,
               p.created_at,
               coalesce((select sum(i.qty)
                           from public.order_items i
                           join public.orders o on o.order_id = i.order_id
                          where i.product_id = p.product_id
                            and o.status not in ('CANCELLED', 'REFUNDED', 'PENDING_PAYMENT')), 0) as sold,
               lower(
                   coalesce(p.name, '') || ' ' ||
                   coalesce(p.brand, '') || ' ' ||
                   coalesce(p.description, '') || ' ' ||
                   coalesce(s.name, '') || ' ' ||
                   coalesce(c.name, '') || ' ' ||
                   coalesce(c.name_th, '') || ' ' ||
                   coalesce(pc.name, '') || ' ' ||
                   coalesce(pc.name_th, '') || ' ' ||
                   coalesce(p.sku, '') || ' ' ||
                   coalesce(p.barcode, '') || ' ' ||
                   coalesce(p.unit, '') || ' ' ||
                   array_to_string(coalesce(p.tags, '{}'), ' ')
               ) as hay
          from public.products p
          join public.shops s on s.shop_id = p.shop_id
          join public.profiles ow on ow.user_id = s.owner_id
          left join public.categories c on c.category_id = p.category_id
          left join public.categories pc on pc.category_id = c.parent_id
         where p.is_active and ow.status = 'active'
    ),
    sel as (
        select *
          from base b
         where (p_category_id is null or b.category_id = p_category_id or b.parent_category_id = p_category_id)
           and (p_shop_id is null or b.shop_id = p_shop_id)
           and (v_brand is null or lower(coalesce(b.brand, '')) = lower(v_brand))
           and (p_min_price is null or b.price >= p_min_price)
           and (p_max_price is null or b.price <= p_max_price)
           and (v_tags is null or b.tags @> v_tags)
           and (not coalesce(p_in_stock, false) or b.stock_qty > 0)
           and (v_exclude is null or not exists (
                    select 1 from unnest(v_exclude) ex
                     where trim(ex) <> '' and b.hay like '%' || lower(trim(ex)) || '%'))
           and (
                (v_q is null and v_terms is null)
                or (v_terms is not null and exists (
                    select 1 from unnest(v_terms) tm
                     where trim(tm) <> '' and b.hay like '%' || lower(trim(tm)) || '%'))
                or (v_terms is null and v_q is not null and b.hay like '%' || lower(v_q) || '%')
           )
    ),
    cat_counts as (
        select c.category_id,
               c.name,
               c.name_th,
               c.parent_id,
               c.slug,
               c.icon,
               c.sort_order,
               (select count(*)
                  from base b
                 where b.category_id = c.category_id or b.parent_category_id = c.category_id) as product_count
          from public.categories c
    ),
    brand_facets as (
        select brand, count(*) as count
          from sel
         where brand is not null and trim(brand) <> ''
         group by brand
         order by count(*) desc, brand asc
         limit 40
    ),
    tag_facets as (
        select t as tag, count(*) as count
          from sel, unnest(sel.tags) as t
         group by t
         order by count(*) desc, t asc
         limit 20
    ),
    shop_facets as (
        select shop_id, shop as name, count(*) as count
          from sel
         group by shop_id, shop
         order by count(*) desc, shop asc
    )
    select jsonb_build_object(
        'total', (select count(*) from sel),
        'categories', coalesce((
            select jsonb_agg(jsonb_build_object(
                       'category_id', category_id,
                       'name', name,
                       'name_th', name_th,
                       'parent_id', parent_id,
                       'slug', slug,
                       'icon', icon,
                       'sort_order', sort_order,
                       'product_count', product_count)
                   order by coalesce(parent_id, 0), sort_order, name)
              from cat_counts), '[]'::jsonb),
        'brands', coalesce((
            select jsonb_agg(jsonb_build_object('brand', brand, 'count', count))
              from brand_facets), '[]'::jsonb),
        'tags', coalesce((
            select jsonb_agg(jsonb_build_object('tag', tag, 'count', count))
              from tag_facets), '[]'::jsonb),
        'shops', coalesce((
            select jsonb_agg(jsonb_build_object('shop_id', shop_id, 'name', name, 'count', count))
              from shop_facets), '[]'::jsonb),
        'items', coalesce((
            select jsonb_agg(to_jsonb(x) - 'hay')
              from (
                select * from sel
                 order by
                    case when p_sort = 'price_asc' then price end asc,
                    case when p_sort = 'price_desc' then price end desc,
                    case when p_sort = 'unit_price_asc' then unit_price end asc,
                    case when p_sort = 'popular' then sold end desc,
                    created_at desc,
                    product_id desc
                 limit least(greatest(p_limit, 1), 100)
                offset greatest(p_offset, 0)
              ) x), '[]'::jsonb)
    ));
end $$;

-- ---------------------------------------------------------------- enhanced product page (adds metadata + related items)
create or replace function public.product_page(p_product_id bigint) returns jsonb
language plpgsql stable security definer set search_path = '' as $$
begin
    if not public.product_visible(p_product_id) then
        raise exception 'Product not found' using errcode = 'PT404';
    end if;
    return (
        select to_jsonb(p) - 'low_stock_threshold' || jsonb_build_object(
            'unit_price', round(p.price / greatest(p.pack_qty, 1), 2),
            'shop', jsonb_build_object('shop_id', s.shop_id, 'name', s.name, 'description', s.description),
            'category', c.name,
            'category_th', c.name_th,
            'parent_category', pc.name,
            'parent_category_th', pc.name_th,
            'shop_coupons', coalesce((
                select jsonb_agg(jsonb_build_object(
                    'code', k.code,
                    'discount_type', k.discount_type,
                    'discount_value', k.discount_value,
                    'min_order_amount', k.min_order_amount,
                    'max_discount', k.max_discount,
                    'expires_at', k.expires_at))
                  from public.coupons k
                 where k.shop_id = s.shop_id and k.is_active
                   and now() between k.starts_at and k.expires_at), '[]'::jsonb),
            'related', coalesce((
                select jsonb_agg(jsonb_build_object(
                    'product_id', r.product_id,
                    'name', r.name,
                    'price', r.price,
                    'image_url', r.image_url,
                    'stock_qty', r.stock_qty,
                    'brand', r.brand,
                    'unit', r.unit,
                    'pack_qty', r.pack_qty,
                    'shop_id', rs.shop_id,
                    'shop', rs.name))
                  from (
                    select p2.*
                      from public.products p2
                      left join public.categories c2 on c2.category_id = p2.category_id
                     where p2.product_id <> p.product_id
                       and public.product_visible(p2.product_id)
                       and (p2.category_id = p.category_id
                            or (c.parent_id is not null and c2.parent_id = c.parent_id)
                            or p2.shop_id = p.shop_id)
                     order by (p2.category_id = p.category_id) desc, (p2.shop_id = p.shop_id) desc, p2.product_id desc
                     limit 4
                  ) r
                  join public.shops rs on rs.shop_id = r.shop_id), '[]'::jsonb)
        )
          from public.products p
          join public.shops s on s.shop_id = p.shop_id
          left join public.categories c on c.category_id = p.category_id
          left join public.categories pc on pc.category_id = c.parent_id
         where p.product_id = p_product_id
    );
end $$;

-- ---------------------------------------------------------------- enhanced seller_product_save (backward-compatible)
create or replace function public.seller_product_save(
    p_product_id          bigint,
    p_name                text,
    p_description         text,
    p_category_id         integer,
    p_price               numeric,
    p_image_url           text,
    p_low_stock_threshold integer,
    p_is_active           boolean,
    p_initial_stock       integer default 0,
    p_brand               text    default null,
    p_sku                 text    default null,
    p_barcode             text    default null,
    p_unit                text    default 'ชิ้น',
    p_pack_qty            integer default 1,
    p_tags                text[]  default '{}'
) returns jsonb
language plpgsql volatile security definer set search_path = '' as $$
declare
    s    bigint := public.my_shop_id();
    v_id bigint;
    v_unit text := coalesce(nullif(trim(coalesce(p_unit, '')), ''), 'ชิ้น');
    v_pack integer := greatest(coalesce(p_pack_qty, 1), 1);
begin
    if p_price is null or p_price <= 0 or p_price <> round(p_price, 2) then
        raise exception 'Price must be more than 0 with at most 2 decimals' using errcode = '22023';
    end if;
    if p_image_url is not null and p_image_url !~ '^https://' then
        raise exception 'The image must be an https:// link' using errcode = '22023';
    end if;
    if p_product_id is null then
        insert into public.products (
            shop_id, name, description, category_id, price, image_url,
            low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags
        )
        values (
            s, trim(p_name), nullif(trim(p_description), ''), p_category_id, p_price, p_image_url,
            coalesce(p_low_stock_threshold, 5), coalesce(p_is_active, true),
            nullif(trim(coalesce(p_brand, '')), ''), nullif(trim(coalesce(p_sku, '')), ''),
            nullif(trim(coalesce(p_barcode, '')), ''), v_unit, v_pack, coalesce(p_tags, '{}')
        )
        returning product_id into v_id;
        if coalesce(p_initial_stock, 0) > 0 then
            perform public.move_stock(v_id, p_initial_stock, 'INITIAL', null, 'Opening stock');
        end if;
    else
        update public.products
           set name = trim(p_name),
               description = nullif(trim(p_description), ''),
               category_id = p_category_id,
               price = p_price,
               image_url = p_image_url,
               low_stock_threshold = coalesce(p_low_stock_threshold, low_stock_threshold),
               is_active = coalesce(p_is_active, is_active),
               brand = coalesce(nullif(trim(coalesce(p_brand, '')), ''), brand),
               sku = coalesce(nullif(trim(coalesce(p_sku, '')), ''), sku),
               barcode = coalesce(nullif(trim(coalesce(p_barcode, '')), ''), barcode),
               unit = coalesce(nullif(trim(coalesce(p_unit, '')), ''), unit),
               pack_qty = greatest(coalesce(p_pack_qty, pack_qty), 1),
               tags = case when p_tags is not null then p_tags else tags end
         where product_id = p_product_id and shop_id = s
        returning product_id into v_id;
        if v_id is null then
            raise exception 'Product not found' using errcode = 'PT404';
        end if;
    end if;
    return (select to_jsonb(p) from public.products p where p.product_id = v_id);
end $$;

-- ---------------------------------------------------------------- public snapshot for Sales Bot (zero PII, active only)
create or replace function public.bot_catalog_snapshot() returns jsonb
language sql stable security definer set search_path = '' as $$
    select jsonb_build_object(
        'products', coalesce((
            select jsonb_agg(jsonb_build_object(
                'product_id', p.product_id,
                'name', p.name,
                'description', p.description,
                'price', p.price,
                'unit_price', round(p.price / greatest(p.pack_qty, 1), 2),
                'image_url', p.image_url,
                'stock_qty', p.stock_qty,
                'category_id', p.category_id,
                'parent_category_id', c.parent_id,
                'category', c.name,
                'category_th', c.name_th,
                'parent_category', pc.name,
                'parent_category_th', pc.name_th,
                'shop_id', s.shop_id,
                'shop', s.name,
                'brand', p.brand,
                'sku', p.sku,
                'barcode', p.barcode,
                'unit', p.unit,
                'pack_qty', p.pack_qty,
                'tags', coalesce(p.tags, '{}'),
                'sold', coalesce((
                    select sum(i.qty)
                      from public.order_items i
                      join public.orders o on o.order_id = i.order_id
                     where i.product_id = p.product_id
                       and o.status not in ('CANCELLED', 'REFUNDED', 'PENDING_PAYMENT')
                ), 0)
            ) order by p.product_id desc)
              from (
                select p.*
                  from public.products p
                  join public.shops s on s.shop_id = p.shop_id
                  join public.profiles ow on ow.user_id = s.owner_id
                 where p.is_active and ow.status = 'active'
                 order by p.product_id desc
                 limit 600
              ) p
              join public.shops s on s.shop_id = p.shop_id
              left join public.categories c on c.category_id = p.category_id
              left join public.categories pc on pc.category_id = c.parent_id
        ), '[]'::jsonb),
        'categories', coalesce((
            select jsonb_agg(jsonb_build_object(
                'category_id', c.category_id,
                'name', c.name,
                'name_th', c.name_th,
                'parent_id', c.parent_id,
                'slug', c.slug,
                'icon', c.icon,
                'sort_order', c.sort_order
            ) order by coalesce(c.parent_id, 0), c.sort_order, c.name)
              from public.categories c
        ), '[]'::jsonb),
        'coupons', coalesce((
            select jsonb_agg(jsonb_build_object(
                'code', k.code,
                'shop_id', k.shop_id,
                'shop', s.name,
                'platform', k.shop_id is null,
                'discount_type', k.discount_type,
                'discount_value', k.discount_value,
                'max_discount', k.max_discount,
                'min_order_amount', k.min_order_amount,
                'expires_at', k.expires_at
            ) order by (k.shop_id is null) desc, k.discount_value desc)
              from public.coupons k
              left join public.shops s on s.shop_id = k.shop_id
             where k.is_active and now() between k.starts_at and k.expires_at
        ), '[]'::jsonb)
    )
$$;

-- ---------------------------------------------------------------- explicit grants
revoke all on function public.catalog(text, integer, bigint, text, integer, integer, text, numeric, numeric, text[], boolean, text[], text[]) from public, anon, authenticated;
grant execute on function public.catalog(text, integer, bigint, text, integer, integer, text, numeric, numeric, text[], boolean, text[], text[]) to anon, authenticated;

revoke all on function public.product_page(bigint) from public, anon, authenticated;
grant execute on function public.product_page(bigint) to anon, authenticated;

revoke all on function public.bot_catalog_snapshot() from public, anon, authenticated;
grant execute on function public.bot_catalog_snapshot() to anon, authenticated;

revoke all on function public.seller_product_save(bigint, text, text, integer, numeric, text, integer, boolean, integer, text, text, text, text, integer, text[]) from public, anon, authenticated;
grant execute on function public.seller_product_save(bigint, text, text, integer, numeric, text, integer, boolean, integer, text, text, text, text, integer, text[]) to authenticated;

commit;
