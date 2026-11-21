-- Workshop 2.1 fix: Supabase Auth sets app_metadata after inserting the user, so the sign-up trigger cannot read the
-- role from it. Instead the API (service key only) writes a short-lived sign-up ticket for the email and role just
-- before it creates the account; the trigger accepts an account only when a fresh ticket exists, and takes the role
-- from it. A sign-up straight to Supabase Auth (no ticket) is refused.

begin;

create table public.signup_tickets (
    email      text primary key,
    role       text not null check (role in ('buyer', 'seller', 'admin')),
    created_at timestamptz not null default now()
);
alter table public.signup_tickets enable row level security;
revoke all on public.signup_tickets from anon, authenticated;
grant select, insert, update, delete on public.signup_tickets to service_role;

create or replace function public.shop_before_signup() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
    if not exists (select 1 from public.signup_tickets t
                    where t.email = lower(new.email) and t.created_at > now() - interval '10 minutes') then
        raise exception 'Please register on the shop website' using errcode = '42501';
    end if;
    return new;
end $$;

create or replace function public.shop_after_signup() returns trigger
language plpgsql security definer set search_path = '' as $$
declare v_role text;
begin
    delete from public.signup_tickets where email = lower(new.email) returning role into v_role;
    insert into public.profiles (user_id, email, display_name, role)
    values (new.id, lower(new.email), coalesce(nullif(trim(new.raw_user_meta_data ->> 'display_name'), ''), split_part(new.email, '@', 1)), v_role);
    if v_role = 'seller' then
        insert into public.shops (owner_id, name, description)
        values (new.id, coalesce(nullif(trim(new.raw_user_meta_data ->> 'shop_name'), ''), split_part(new.email, '@', 1) || ' shop'),
                nullif(trim(new.raw_user_meta_data ->> 'shop_description'), ''));
    end if;
    return new;
end $$;

revoke all on function public.shop_before_signup(), public.shop_after_signup() from public, anon, authenticated;

commit;
