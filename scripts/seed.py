"""Seed FDE Shop with demo accounts, 12 main categories + 36 subcategories, 6 shops, ~200 products, and coupons (idempotent).

  uv run python scripts/seed.py

Accounts (passwords generated once and appended to .env, never printed):
  SHOP_ADMIN (platform admin), SHOP_SELLER_A..F (six multi-category shops), SHOP_BUYER_1 / SHOP_BUYER_2.
"""
import json
import secrets
import string
import urllib.error
import urllib.parse
import urllib.request
from datetime import datetime, timedelta, timezone
from pathlib import Path

from catalog_data import ACCOUNTS, CATEGORY_TREE, SHOP_COUPONS, build_product_records

ROOT = Path(__file__).resolve().parents[1]
ENV_FILE = ROOT / ".env"


def env() -> dict:
    return {
        k.strip(): v.strip()
        for k, v in (l.split("=", 1) for l in ENV_FILE.read_text(encoding="utf-8").splitlines() if "=" in l)
    }


E = env()
URL, ANON, SVC = E["SUPABASE_URL"], E["SUPABASE_ANON_KEY"], E["SUPABASE_SERVICE_ROLE_KEY"]


def http(method, url, headers, body=None):
    req = urllib.request.Request(
        url,
        method=method,
        data=json.dumps(body).encode() if body is not None else None,
        headers={"Content-Type": "application/json", **headers},
    )
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            raw = r.read()
            return r.status, json.loads(raw) if raw else None
    except urllib.error.HTTPError as e:
        raw = e.read()
        try:
            return e.code, json.loads(raw) if raw else None
        except ValueError:
            return e.code, raw.decode("utf-8", errors="replace")


SVC_H = {"apikey": SVC, "Authorization": f"Bearer {SVC}"}


def ensure_account(prefix, email, name, role, shop, shop_desc=None):
    global E
    if f"{prefix}_PASSWORD" not in E:
        pw = "Shop-" + "".join(secrets.choice(string.ascii_letters + string.digits) for _ in range(14))
        http(
            "POST",
            f"{URL}/rest/v1/signup_tickets",
            {**SVC_H, "Prefer": "resolution=merge-duplicates"},
            {"email": email, "role": role, "created_at": datetime.now(timezone.utc).isoformat()},
        )
        st, out = http(
            "POST",
            f"{URL}/auth/v1/admin/users",
            SVC_H,
            {
                "email": email,
                "password": pw,
                "email_confirm": True,
                "app_metadata": {"via": "api", "role": role},
                "user_metadata": {
                    "display_name": name,
                    "shop_name": shop or "",
                    "shop_description": shop_desc or "",
                },
            },
        )
        if st not in (200, 201):
            raise SystemExit(f"create {email} failed: {st} {out}")
        with ENV_FILE.open("a", encoding="utf-8") as f:
            f.write(f"{prefix}_EMAIL={email}\n{prefix}_PASSWORD={pw}\n")
        E = env()
        print("created", prefix, email)
    st, out = http(
        "POST",
        f"{URL}/auth/v1/token?grant_type=password",
        {"apikey": ANON},
        {"email": E[f"{prefix}_EMAIL"], "password": E[f"{prefix}_PASSWORD"]},
    )
    if st != 200:
        raise SystemExit(f"sign-in {prefix} failed: {st}")
    return out["access_token"]


def rpc(token, name, body=None):
    st, out = http(
        "POST",
        f"{URL}/rest/v1/rpc/{name}",
        {"apikey": ANON, "Authorization": f"Bearer {token}"},
        body or {},
    )
    if st >= 300:
        raise SystemExit(f"{name} failed: {st} {out}")
    return out


def ensure_categories() -> dict[str, int]:
    st, existing_rows = http("GET", f"{URL}/rest/v1/categories?select=category_id,name", SVC_H)
    if st >= 300:
        raise SystemExit(f"fetch categories failed: {st} {existing_rows}")
    by_name = {c["name"]: c["category_id"] for c in existing_rows}

    for name, name_th, slug, icon, sort_order, children in CATEGORY_TREE:
        payload = {"name": name, "name_th": name_th, "slug": slug, "icon": icon, "sort_order": sort_order, "parent_id": None}
        if name not in by_name:
            st, out = http("POST", f"{URL}/rest/v1/categories", {**SVC_H, "Prefer": "return=representation"}, payload)
            if st >= 300:
                raise SystemExit(f"insert category {name} failed: {st} {out}")
            by_name[name] = out[0]["category_id"]
        else:
            http("PATCH", f"{URL}/rest/v1/categories?category_id=eq.{by_name[name]}", SVC_H, payload)

        parent_id = by_name[name]
        for idx, (cname, cname_th, cslug, cicon) in enumerate(children, start=1):
            cpayload = {
                "name": cname,
                "name_th": cname_th,
                "slug": cslug,
                "icon": cicon,
                "sort_order": sort_order * 10 + idx,
                "parent_id": parent_id,
            }
            if cname not in by_name:
                st, out = http("POST", f"{URL}/rest/v1/categories", {**SVC_H, "Prefer": "return=representation"}, cpayload)
                if st >= 300:
                    raise SystemExit(f"insert subcategory {cname} failed: {st} {out}")
                by_name[cname] = out[0]["category_id"]
            else:
                http("PATCH", f"{URL}/rest/v1/categories?category_id=eq.{by_name[cname]}", SVC_H, cpayload)

    return by_name


def main():
    tokens = {a[0]: ensure_account(*a) for a in ACCOUNTS}
    cats = ensure_categories()
    print(f"categories synced: {len(cats)}")

    records = build_product_records()
    by_seller: dict[str, list[dict]] = {}
    for rec in records:
        by_seller.setdefault(rec["seller"], []).append(rec)

    created = 0
    updated = 0
    for seller, items in by_seller.items():
        existing = {p["name"]: p for p in rpc(tokens[seller], "seller_products")}
        for item in items:
            cat_id = cats.get(item["category"])
            prev = existing.get(item["name"])
            if prev is None:
                rpc(
                    tokens[seller],
                    "seller_product_save",
                    {
                        "p_product_id": None,
                        "p_name": item["name"],
                        "p_description": item["description"],
                        "p_category_id": cat_id,
                        "p_price": item["price"],
                        "p_image_url": item["image_url"],
                        "p_low_stock_threshold": 5,
                        "p_is_active": True,
                        "p_initial_stock": item["stock_qty"],
                        "p_brand": item["brand"],
                        "p_sku": item["sku"],
                        "p_barcode": item["barcode"],
                        "p_unit": item["unit"],
                        "p_pack_qty": item["pack_qty"],
                        "p_tags": item["tags"],
                    },
                )
                created += 1
            elif not prev.get("brand") or not prev.get("tags"):
                # Enrich previously seeded products with brand/unit/tags/subcategory without changing stock
                rpc(
                    tokens[seller],
                    "seller_product_save",
                    {
                        "p_product_id": prev["product_id"],
                        "p_name": prev["name"],
                        "p_description": item["description"],
                        "p_category_id": cat_id or prev["category_id"],
                        "p_price": prev["price"],
                        "p_image_url": prev["image_url"] or item["image_url"],
                        "p_low_stock_threshold": prev["low_stock_threshold"],
                        "p_is_active": prev["is_active"],
                        "p_initial_stock": 0,
                        "p_brand": item["brand"],
                        "p_sku": item["sku"],
                        "p_barcode": item["barcode"],
                        "p_unit": item["unit"],
                        "p_pack_qty": item["pack_qty"],
                        "p_tags": item["tags"],
                    },
                )
                updated += 1
    print(f"products synced: created={created}, enriched={updated}, total_defined={len(records)}")

    now = datetime.now(timezone.utc)
    for seller, code, dtype, dval, max_d, min_amt, lim_tot, lim_usr in SHOP_COUPONS:
        have_codes = {c["code"] for c in rpc(tokens[seller], "seller_coupons")}
        if code not in have_codes:
            rpc(
                tokens[seller],
                "coupon_save",
                {
                    "p_code": code,
                    "p_discount_type": dtype,
                    "p_discount_value": dval,
                    "p_max_discount": max_d,
                    "p_min_order_amount": min_amt,
                    "p_usage_limit_total": lim_tot,
                    "p_usage_limit_per_user": lim_usr,
                    "p_starts_at": None,
                    "p_expires_at": (now + timedelta(days=90)).isoformat(),
                },
            )
            print("coupon", seller, code)

    if not rpc(tokens["SHOP_ADMIN"], "admin_campaigns"):
        products = rpc(tokens["SHOP_ADMIN"], "catalog", {"p_limit": 8, "p_sort": "price_desc"})["items"]
        camp = rpc(
            tokens["SHOP_ADMIN"],
            "admin_campaign_save",
            {
                "p_name": "12.12 Mega Sale",
                "p_description": "Platform-wide discount: THB 50 off from THB 500, paid by the platform.",
                "p_starts_at": (now - timedelta(hours=1)).isoformat(),
                "p_ends_at": (now + timedelta(days=45)).isoformat(),
                "p_product_ids": [p["product_id"] for p in products],
            },
        )
        rpc(
            tokens["SHOP_ADMIN"],
            "coupon_save",
            {
                "p_code": "MEGA50",
                "p_discount_type": "FIXED",
                "p_discount_value": 50,
                "p_max_discount": None,
                "p_min_order_amount": 500,
                "p_usage_limit_total": 500,
                "p_usage_limit_per_user": 2,
                "p_starts_at": None,
                "p_expires_at": (now + timedelta(days=45)).isoformat(),
                "p_campaign_id": camp["campaign_id"],
            },
        )
        print("campaign + MEGA50")
    print("seed done")


if __name__ == "__main__":
    main()
