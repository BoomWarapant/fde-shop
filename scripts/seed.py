"""Seed FDE Shop with demo accounts and a small catalogue (idempotent: skips what already exists).

  uv run python scripts/seed.py

Accounts (passwords generated once and appended to .env, never printed):
  SHOP_ADMIN (platform admin), SHOP_SELLER_A / SHOP_SELLER_B (two shops), SHOP_BUYER_1 / SHOP_BUYER_2.
"""
import json
import secrets
import string
import urllib.error
import urllib.request
from datetime import datetime, timedelta, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ENV_FILE = ROOT / ".env"


def env() -> dict:
    return {k.strip(): v.strip() for k, v in (l.split("=", 1) for l in ENV_FILE.read_text(encoding="utf-8").splitlines() if "=" in l)}


E = env()
URL, ANON, SVC = E["SUPABASE_URL"], E["SUPABASE_ANON_KEY"], E["SUPABASE_SERVICE_ROLE_KEY"]


def http(method, url, headers, body=None):
    req = urllib.request.Request(url, method=method, data=json.dumps(body).encode() if body is not None else None,
                                 headers={"Content-Type": "application/json", **headers})
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            raw = r.read()
            return r.status, json.loads(raw) if raw else None
    except urllib.error.HTTPError as e:
        raw = e.read()
        return e.code, json.loads(raw) if raw else None


SVC_H = {"apikey": SVC, "Authorization": f"Bearer {SVC}"}

ACCOUNTS = [
    ("SHOP_ADMIN", "admin@fdeshop-demo.com", "Platform Admin", "admin", None),
    ("SHOP_SELLER_A", "seller.a@fdeshop-demo.com", "Somsri Home", "seller", "Somsri Home & Living"),
    ("SHOP_SELLER_B", "seller.b@fdeshop-demo.com", "Tech Corner", "seller", "Tech Corner BKK"),
    ("SHOP_BUYER_1", "buyer.one@fdeshop-demo.com", "Nok Buyer", "buyer", None),
    ("SHOP_BUYER_2", "buyer.two@fdeshop-demo.com", "Ton Buyer", "buyer", None),
]


def ensure_account(prefix, email, name, role, shop):
    global E
    if f"{prefix}_PASSWORD" not in E:
        pw = "Shop-" + "".join(secrets.choice(string.ascii_letters + string.digits) for _ in range(14))
        http("POST", f"{URL}/rest/v1/signup_tickets", {**SVC_H, "Prefer": "resolution=merge-duplicates"}, {"email": email, "role": role, "created_at": datetime.now(timezone.utc).isoformat()})
        st, out = http("POST", f"{URL}/auth/v1/admin/users", SVC_H, {
            "email": email, "password": pw, "email_confirm": True, "app_metadata": {"via": "api", "role": role},
            "user_metadata": {"display_name": name, "shop_name": shop or ""}})
        if st not in (200, 201):
            raise SystemExit(f"create {email} failed: {st} {out}")
        with ENV_FILE.open("a", encoding="utf-8") as f:
            f.write(f"{prefix}_EMAIL={email}\n{prefix}_PASSWORD={pw}\n")
        E = env()
        print("created", prefix, email)
    st, out = http("POST", f"{URL}/auth/v1/token?grant_type=password", {"apikey": ANON},
                   {"email": E[f"{prefix}_EMAIL"], "password": E[f"{prefix}_PASSWORD"]})
    if st != 200:
        raise SystemExit(f"sign-in {prefix} failed: {st}")
    return out["access_token"]


def rpc(token, name, body=None):
    st, out = http("POST", f"{URL}/rest/v1/rpc/{name}", {"apikey": ANON, "Authorization": f"Bearer {token}"}, body or {})
    if st >= 300:
        raise SystemExit(f"{name} failed: {st} {out}")
    return out


CATEGORIES = ["Home & Living", "Electronics", "Fashion", "Beauty", "Sports", "Food & Drinks"]
IMG = "https://images.unsplash.com/photo-{}?w=600&q=70&auto=format&fit=crop"
PRODUCTS = {
    "SHOP_SELLER_A": [
        ("Ceramic coffee mug 350 ml", "Home & Living", 129, 40, "1514228742587-6b1558fcca3d"),
        ("Linen cushion cover 45x45", "Home & Living", 259, 25, "1584100936595-c0654b55a2e2"),
        ("Bamboo cutting board", "Home & Living", 349, 15, None),
        ("Scented soy candle", "Beauty", 199, 3, "1602874801007-bd458bb1b8b6"),
        ("Cotton tote bag", "Fashion", 159, 60, "1597484661643-2f5fef640dd1"),
        ("Glass water bottle 600 ml", "Sports", 289, 1, "1602143407151-7111542de6e8"),
    ],
    "SHOP_SELLER_B": [
        ("USB-C fast charger 30W", "Electronics", 490, 30, "1583863788434-e58a36330cf0"),
        ("Wireless earbuds", "Electronics", 1290, 12, "1590658268037-6bf12165a8df"),
        ("Phone stand aluminium", "Electronics", 350, 20, "1586953208448-b95a79798f07"),
        ("Mechanical keyboard 75%", "Electronics", 2490, 4, "1587829741301-dc798b83add3"),
        ("Laptop sleeve 14 inch", "Fashion", 590, 18, "1525547719571-a2d4ac8945e2"),
    ],
}


def main():
    tokens = {a[0]: ensure_account(*a) for a in ACCOUNTS}
    st, cats = http("GET", f"{URL}/rest/v1/categories?select=category_id,name", SVC_H)
    have = {c["name"] for c in cats}
    for c in CATEGORIES:
        if c not in have:
            http("POST", f"{URL}/rest/v1/categories", SVC_H, {"name": c})
    cats = {c["name"]: c["category_id"] for c in http("GET", f"{URL}/rest/v1/categories?select=category_id,name", SVC_H)[1]}
    now = datetime.now(timezone.utc)
    for seller, items in PRODUCTS.items():
        existing = {p["name"] for p in rpc(tokens[seller], "seller_products")}
        for name, cat, price, stock, photo in items:
            if name not in existing:
                rpc(tokens[seller], "seller_product_save", {
                    "p_product_id": None, "p_name": name, "p_description": f"{name}. Demo product for the FDE 101 marketplace workshop.",
                    "p_category_id": cats[cat], "p_price": price, "p_image_url": IMG.format(photo) if photo else None, "p_low_stock_threshold": 5,
                    "p_is_active": True, "p_initial_stock": stock})
                print("product", seller, name)
    if not rpc(tokens["SHOP_SELLER_A"], "seller_coupons"):
        rpc(tokens["SHOP_SELLER_A"], "coupon_save", {"p_code": "SOMSRI10", "p_discount_type": "PERCENT", "p_discount_value": 10,
                                                     "p_max_discount": 100, "p_min_order_amount": 300, "p_usage_limit_total": 100,
                                                     "p_usage_limit_per_user": 1, "p_starts_at": None,
                                                     "p_expires_at": (now + timedelta(days=60)).isoformat()})
        print("coupon SOMSRI10")
    if not rpc(tokens["SHOP_ADMIN"], "admin_campaigns"):
        products = rpc(tokens["SHOP_ADMIN"], "catalog", {"p_limit": 4, "p_sort": "price_desc"})["items"]
        camp = rpc(tokens["SHOP_ADMIN"], "admin_campaign_save", {
            "p_name": "12.12 Mega Sale", "p_description": "Platform-wide discount: THB 50 off from THB 500, paid by the platform.",
            "p_starts_at": (now - timedelta(hours=1)).isoformat(), "p_ends_at": (now + timedelta(days=30)).isoformat(),
            "p_product_ids": [p["product_id"] for p in products]})
        rpc(tokens["SHOP_ADMIN"], "coupon_save", {"p_code": "MEGA50", "p_discount_type": "FIXED", "p_discount_value": 50, "p_max_discount": None,
                                                  "p_min_order_amount": 500, "p_usage_limit_total": 500, "p_usage_limit_per_user": 2,
                                                  "p_starts_at": None, "p_expires_at": (now + timedelta(days=30)).isoformat(),
                                                  "p_campaign_id": camp["campaign_id"]})
        print("campaign + MEGA50")
    print("seed done")


if __name__ == "__main__":
    main()
