# FDE Shop: multi-vendor marketplace (FDE 101 Workshop 2.1)

A Shopee-style marketplace built as a **separate app** from A-ERP, with the same approach: rules in the database,
a thin FastAPI layer, a React front end.

**URL:** https://fde-shop-liard.vercel.app · demo data only, no real payments.

## What it does

| Who | Can |
|---|---|
| Anyone | browse 12 main categories / 36 subcategories (~200+ products across 6 shops), use MarketBrain-style **Smart Search** (budget e.g. `"ไม่เกิน 200"`, exclusions `"-ทิพรส"`, Thai↔English synonyms, brand/price/trait facets), chat with **น้องเอฟดี (Sales Concierge)** at `/assistant` or via the floating concierge drawer |
| Buyer | register, add to cart directly from cards or via chat (`"เอาเบอร์ 1 2 ชิ้น"`), compare products side-by-side, check coupons & free-shipping progress, checkout (one order per shop), pay by bank-transfer slip, track the order timeline, mark as received, cancel unpaid orders, request a refund |
| Seller | register with a shop; post and edit products (with brand, SKU, barcode, unit/pack size, and trait badges); stock (restock / adjust, movement history, low-stock alert); promotions (shop coupons); check slips, ship with carrier + tracking, mark delivered; decide refunds; accounting (sales, discounts, 5 % platform fee, refunds, net payout by month and order); customers (Frequent 3+ / Repeat 2 / New 1 orders) |
| Platform admin | overview (GMV, platform fees, top-selling shops), users (ban / unban with a reason), campaigns (banner, featured products, platform coupons paid by the platform) |

## Rules (all enforced in `supabase/migrations/*.sql`)

- **Accounts:** register only through `POST /api/register` (buyer or seller). It writes a short-lived sign-up ticket with
  the service key, then creates the Supabase Auth user; a trigger refuses any sign-up without a ticket and takes the
  role from it. A banned user is refused by every function at once and cannot sign in.
- **Isolation:** users have no table grants (RLS on, no policies). Every read / write is a `security definer` function
  that checks the caller: buyers see only their own orders, sellers only their own shop; another shop's order or product
  is "not found".
- **Money:** prices, coupon discounts, shipping (THB 40, free from THB 500 after discount) and totals are computed by
  `price_cart()`; the API has no price / total fields.
- **Stock:** checkout decrements with `stock_qty >= qty` in the same transaction as the order; if any line is short the
  whole checkout fails (409), so two buyers cannot both get the last item. Cancel (unpaid) and refunds of unshipped orders
  put stock back. Every change is a `stock_movements` row.
- **Coupons:** percent / fixed, cap, minimum spend, start / expiry, total and per-user limits; the coupon row is locked
  during checkout so limits hold under concurrency. Shop coupons = promotions (paid by the shop); platform coupons =
  campaigns (paid by the platform).
- **Orders:** `PENDING_PAYMENT → TO_SHIP` (seller approves the slip; amount must equal the total) `→ SHIPPED` (carrier +
  tracking) `→ DELIVERED`; or `CANCELLED` (unpaid; also automatically after 24 h by the daily cron) / `REFUNDED`.
  Every step is a `shipment_events` row: buyer and seller see the same timeline.
- **Slips:** private Storage bucket `payment-slips/<buyer>/<order>/…`; only the buyer, that order's seller and admins
  can read a slip; `trans_ref` is unique, so a slip cannot pay twice.

## Run locally

```bash
# .env (git-ignored): SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY, CRON_SECRET (+ demo accounts from the seed)
# web/.env.local: VITE_SUPABASE_URL, VITE_SUPABASE_ANON_KEY
uv sync
set -a; . ./.env; set +a
uv run uvicorn shop_api.app:app --app-dir src --port 8020   # API (also serves web/dist when built)
cd web && npm install && npm run dev                         # web on :5190, /api proxied to :8020
```

Database: apply `supabase/migrations/*.sql` in order with
`supabase db query --remote=<project ref> -f <file> --yes`, then `uv run python scripts/seed.py` (creates the demo
accounts with generated passwords appended to `.env`, categories, products, a shop coupon `SOMSRI10` and the campaign
coupon `MEGA50`).

## Demo accounts

| Role | Email |
|---|---|
| Platform admin | admin@fdeshop-demo.com |
| Seller (Somsri Home & Living) | seller.a@fdeshop-demo.com |
| Seller (Tech Corner BKK) | seller.b@fdeshop-demo.com |
| Buyer | buyer.one@fdeshop-demo.com, buyer.two@fdeshop-demo.com |

Passwords are in the owner's `.env` only. Anyone can also register a new buyer or seller on the site.

## Tests

```bash
SHOP_LIVE_TESTS=1 SHOP_API_BASE=http://127.0.0.1:8020 uv run python -m unittest tests.test_shop_live -v   # omit SHOP_API_BASE for production
```

Seven live tests: Seller A cannot read or change Seller B's products, stock or orders (API, RPC and REST); two buyers
check out the last item at the same moment (exactly one succeeds, stock 0, never negative); expired / below-minimum /
unknown / fully-used coupons are refused with a clear message and browser totals are ignored; slip → approve → ship →
deliver timeline is the same for buyer and seller, a reused transfer reference is refused, slips are private; refund
and seller accounting; stock alerts and adjustments; registration only through the API and bans take effect at once.
Each test deletes what it created.

## Deploy and keep alive

- Vercel project `fde-shop` (region sin1, Supabase project `fde-shop` in ap-southeast-1). `vercel deploy --prod --yes`.
- Env vars: `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY` (server only), `CRON_SECRET`,
  `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY` (public by design).
- `GET /api/health` (200 / 503); daily cron `/api/cron/expire-orders` (with `CRON_SECRET`) cancels unpaid orders after
  24 h and returns their stock.

## Known limitations

- No real payment gateway or automatic slip reading: the seller compares the slip with the order and approves it.
- Stock is per product (no size / colour variants); one coupon per order; flat shipping fee.
- A refund after shipping does not put stock back (the goods are with the buyer); returns are not tracked.
- The registration rate limit is per server instance (in memory).
- Product images are links (https), not uploads.
