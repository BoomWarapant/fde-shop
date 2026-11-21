# CLAUDE.md — FDE Shop (Workshop 2.1 marketplace)

Read README.md first. Same conventions as the A-ERP repo (D:\FDE101\fde-erp\CLAUDE.md).

- **Rules live in the database** (`supabase/migrations/`). Every callable function is `security definer
  set search_path = ''`, starts with `public.me()` / `require_role()` / `my_shop_id()` and qualifies names with `public.`.
  Users have no table grants; the grants loop at the end of the first migration lists every callable function, so add
  new ones there (or grant explicitly in the new migration).
- Money is computed only in `price_cart()` / `coupon_check()`; never accept prices or totals from the browser.
- Stock changes go through `move_stock()` or the guarded `update … where stock_qty >= qty` in `checkout()`; always write a
  `stock_movements` row. Order status changes always add a `shipment_events` row via `order_event()`.
- Out-of-scope records raise `PT404` (not found). Errors: `42501` → 403, `22023` → 400, `PT404` → 404, `PT409` → 409.
- Sign-up: only `POST /api/register` (service-key ticket in `signup_tickets`, then Supabase Auth admin create).
- Apply migrations with `supabase db query --remote=xsjiuymwxkbfcczgphss -f <file> --yes`; there is no history table.
- Live tests (`tests/test_shop_live.py`) must clean up everything they create (orders first, then coupons, products,
  Storage objects) and must not change the seeded accounts.
- Never print or commit `.env` values; `backups/`, `.env*` and `.vercel` are git-ignored. Do not push without the owner's OK.
