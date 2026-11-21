"""Workshop 2.1: live marketplace test against the fde-shop Supabase project and the API.

Skipped unless SHOP_LIVE_TESTS=1. Uses the seeded accounts in .env (SHOP_SELLER_A/B, SHOP_BUYER_1/2, SHOP_ADMIN) and
SUPABASE_SERVICE_ROLE_KEY to remove everything a test created. SHOP_API_BASE = API under test (default production).

  SHOP_LIVE_TESTS=1 SHOP_API_BASE=http://127.0.0.1:8020 uv run python -m unittest tests.test_shop_live -v
"""
import json
import os
import threading
import unittest
import urllib.error
import urllib.request
import uuid
from datetime import datetime, timedelta, timezone
from decimal import Decimal
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LIVE = os.environ.get("SHOP_LIVE_TESTS") == "1"
ENV = {k.strip(): v.strip() for k, v in (l.split("=", 1) for l in (ROOT / ".env").read_text(encoding="utf-8").splitlines() if "=" in l)} if (ROOT / ".env").exists() else {}
URL, ANON, SVC = ENV.get("SUPABASE_URL", ""), ENV.get("SUPABASE_ANON_KEY", ""), ENV.get("SUPABASE_SERVICE_ROLE_KEY", "")
API = os.environ.get("SHOP_API_BASE", "https://fde-shop-liard.vercel.app").rstrip("/")
SVC_H = {"apikey": SVC, "Authorization": f"Bearer {SVC}"}
D = lambda x: Decimal(str(x))  # noqa: E731
ADDR = {"ship_name": "Test Buyer", "ship_phone": "0812345678", "ship_address": "99/1 Test Road, Bangkok 10110"}


def http(method, url, headers=None, body=None, raw: bytes | None = None, ctype="application/json"):
    data = raw if raw is not None else (json.dumps(body).encode() if body is not None else None)
    req = urllib.request.Request(url, method=method, data=data, headers={"Content-Type": ctype, **(headers or {})})
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            b = r.read()
            return r.status, json.loads(b) if b else None
    except urllib.error.HTTPError as e:
        b = e.read()
        try:
            return e.code, json.loads(b) if b else None
        except ValueError:
            return e.code, None


class Who:
    def __init__(self, prefix):
        st, out = http("POST", f"{URL}/auth/v1/token?grant_type=password", {"apikey": ANON},
                       {"email": ENV[f"{prefix}_EMAIL"], "password": ENV[f"{prefix}_PASSWORD"]})
        assert st == 200, f"{prefix} sign-in failed {st}"
        self.token, self.uid = out["access_token"], out["user"]["id"]

    def api(self, method, path, body=None):
        return http(method, f"{API}{path}", {"Authorization": f"Bearer {self.token}"}, body)

    def rpc(self, name, body=None):
        return http("POST", f"{URL}/rest/v1/rpc/{name}", {"apikey": ANON, "Authorization": f"Bearer {self.token}"}, body or {})

    def rest(self, method, path, body=None):
        return http(method, f"{URL}/rest/v1/{path}", {"apikey": ANON, "Authorization": f"Bearer {self.token}"}, body)


def svc(method, path, body=None):
    st, out = http(method, f"{URL}/rest/v1/{path}", {**SVC_H, "Prefer": "return=representation"}, body)
    assert st in (200, 201, 204), (method, path, st, out)
    return out


@unittest.skipUnless(LIVE, "set SHOP_LIVE_TESTS=1 to run against the live fde-shop project")
class ShopLiveTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.sa, cls.sb, cls.b1, cls.b2, cls.admin = (Who(p) for p in ("SHOP_SELLER_A", "SHOP_SELLER_B", "SHOP_BUYER_1", "SHOP_BUYER_2", "SHOP_ADMIN"))
        cls.shop_a = cls.sa.api("GET", "/api/me")[1]["shop"]["shop_id"]
        cls.shop_b = cls.sb.api("GET", "/api/me")[1]["shop"]["shop_id"]
        cls.b_product = cls.sb.api("GET", "/api/seller/products")[1][0]

    def setUp(self):
        self.products, self.coupons, self.orders, self.files = [], [], [], []
        for b in (self.b1, self.b2):
            svc("DELETE", f"cart_items?user_id=eq.{b.uid}")

    def tearDown(self):
        for oid in self.orders:  # unpaid orders: cancel first so seeded products get their stock back
            for b in (self.b1, self.b2):
                b.api("POST", f"/api/orders/{oid}/cancel", {"reason": "test clean-up"})
        if self.files:
            http("DELETE", f"{URL}/storage/v1/object/payment-slips", SVC_H, {"prefixes": self.files})
        if self.orders:
            svc("DELETE", f"orders?order_id=in.({','.join(map(str, self.orders))})")
        for b in (self.b1, self.b2):
            svc("DELETE", f"cart_items?user_id=eq.{b.uid}")
        if self.coupons:
            svc("DELETE", f"coupons?coupon_id=in.({','.join(map(str, self.coupons))})")
        if self.products:
            svc("DELETE", f"products?product_id=in.({','.join(map(str, self.products))})")

    # ------------------------------------------------------------ helpers
    def product(self, stock=10, price="200.00"):
        st, p = self.sa.api("POST", "/api/seller/products", {"name": f"Test item {uuid.uuid4().hex[:6]}", "price": price, "initial_stock": stock})
        self.assertEqual(st, 201, p)
        self.products.append(p["product_id"])
        return p

    def coupon(self, **kw):
        now = datetime.now(timezone.utc)
        body = {"code": "T" + uuid.uuid4().hex[:8].upper(), "discount_type": "FIXED", "discount_value": "20", "min_order_amount": "0",
                "expires_at": (now + timedelta(days=1)).isoformat(), **kw}
        st, c = self.sa.api("POST", "/api/seller/coupons", body)
        self.assertEqual(st, 201, c)
        self.coupons.append(c["coupon_id"])
        return c

    def buy(self, who, product_id, qty=1, coupon=None, expect=201):
        self.assertEqual(who.api("PUT", f"/api/cart/{product_id}", {"qty": qty})[0], 200)
        st, o = who.api("POST", "/api/checkout", {"shop_id": self.shop_a, "coupon": coupon, **ADDR})
        self.assertEqual(st, expect, o)
        if st == 201:
            self.orders.append(o["order_id"])
        return o

    def stock(self, product_id):
        return svc("GET", f"products?select=stock_qty&product_id=eq.{product_id}")[0]["stock_qty"]

    def pay(self, who, order):
        path = f"{who.uid}/{order['order_id']}/slip-{uuid.uuid4().hex[:6]}.png"
        st, _ = http("POST", f"{URL}/storage/v1/object/payment-slips/{path}", {"apikey": ANON, "Authorization": f"Bearer {who.token}"},
                     raw=b"\x89PNG\r\n\x1a\n" + b"0" * 64, ctype="image/png")
        self.assertEqual(st, 200, "slip upload")
        self.files.append(path)
        ref = "TX" + uuid.uuid4().hex[:10].upper()
        st, o = who.api("POST", f"/api/orders/{order['order_id']}/slip", {"trans_ref": ref, "amount": str(order["total"]), "slip_path": path})
        self.assertEqual(st, 201, o)
        return o, ref, path

    # ------------------------------------------------------------ done-when 1: Seller A cannot touch Seller B
    def test_seller_isolation(self):
        bp = self.b_product["product_id"]
        body = {"name": "hacked", "price": "1.00"}
        self.assertEqual(self.sa.api("PUT", f"/api/seller/products/{bp}", body)[0], 404)
        self.assertEqual(self.sa.rpc("seller_product_save", {"p_product_id": bp, "p_name": "hacked", "p_description": None, "p_category_id": None,
                                                              "p_price": 1, "p_image_url": None, "p_low_stock_threshold": 1, "p_is_active": True})[0], 404)
        self.assertEqual(self.sa.api("POST", f"/api/seller/products/{bp}/stock", {"change": -1, "reason": "ADJUST"})[0], 404)
        self.assertEqual(self.sa.api("GET", f"/api/seller/products/{bp}/movements")[0], 404)
        self.assertNotIn(bp, [p["product_id"] for p in self.sa.api("GET", "/api/seller/products")[1]])
        for table in ("products", "orders", "shops", "profiles", "coupons", "payment_slips"):
            self.assertIn(self.sa.rest("GET", f"{table}?select=*&limit=1")[0], (401, 403), table)
            self.assertIn(http("GET", f"{URL}/rest/v1/{table}?select=*&limit=1", {"apikey": ANON})[0], (401, 403), table)
        self.assertIn(self.sa.rest("PATCH", f"products?product_id=eq.{bp}", {"price": 1})[0], (401, 403))
        # sign-up tickets decide the role of a new account: only the server (service key) may write them
        ticket = {"email": f"x{uuid.uuid4().hex[:6]}@fdeshop-demo.com", "role": "admin"}
        self.assertIn(self.b1.rest("POST", "signup_tickets", ticket)[0], (401, 403))
        self.assertIn(http("POST", f"{URL}/rest/v1/signup_tickets", {"apikey": ANON}, ticket)[0], (401, 403))
        self.assertIn(self.b1.rest("GET", "signup_tickets?select=*")[0], (401, 403))
        # Seller B's order is invisible to Seller A and to another buyer
        self.assertEqual(self.b1.api("PUT", f"/api/cart/{bp}", {"qty": 1})[0], 200)
        st, ob = self.b1.api("POST", "/api/checkout", {"shop_id": self.shop_b, **ADDR})
        self.assertEqual(st, 201, ob)
        self.orders.append(ob["order_id"])
        for who in (self.sa, self.b2):
            self.assertEqual(who.api("GET", f"/api/orders/{ob['order_id']}")[0], 404)
        self.assertEqual(self.sa.api("POST", f"/api/seller/orders/{ob['order_id']}/ship", {"carrier": "Kerry", "tracking_number": "KER123456"})[0], 404)
        self.assertEqual(self.sb.api("GET", f"/api/orders/{ob['order_id']}")[1]["viewer"], "seller")
        self.assertNotIn(ob["order_id"], [o["order_id"] for o in self.sa.api("GET", "/api/seller/orders")[1]])
        # roles: buyers cannot use the seller centre, sellers cannot buy, nobody but admins reaches admin
        self.assertEqual(self.b1.api("GET", "/api/seller/products")[0], 403)
        self.assertEqual(self.sa.api("GET", "/api/cart")[0], 403)
        self.assertEqual(self.sa.api("GET", "/api/admin/users")[0], 403)

    # ------------------------------------------------------------ done-when 2: last item, two buyers at once
    def test_last_item_two_buyers_at_once(self):
        p = self.product(stock=1)
        for b in (self.b1, self.b2):
            self.assertEqual(b.api("PUT", f"/api/cart/{p['product_id']}", {"qty": 1})[0], 200)
        results, barrier = {}, threading.Barrier(2)

        def go(b):
            barrier.wait()
            results[b.uid] = b.api("POST", "/api/checkout", {"shop_id": self.shop_a, **ADDR})
        threads = [threading.Thread(target=go, args=(b,)) for b in (self.b1, self.b2)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()
        codes = sorted(st for st, _ in results.values())
        for st, o in results.values():
            if st == 201:
                self.orders.append(o["order_id"])
        self.assertEqual(codes, [201, 409], results)
        self.assertEqual(self.stock(p["product_id"]), 0)
        loser = next(o for st, o in results.values() if st == 409)
        self.assertIn("Not enough stock", loser["detail"])
        moves = svc("GET", f"stock_movements?select=qty_change,reason&product_id=eq.{p['product_id']}&order=movement_id")
        self.assertEqual([(m["qty_change"], m["reason"]) for m in moves], [(1, "INITIAL"), (-1, "SALE")])

    # ------------------------------------------------------------ done-when 3: bad coupons are refused by the server
    def test_coupon_rules(self):
        p = self.product(stock=20, price="100.00")
        past = datetime.now(timezone.utc) - timedelta(days=2)
        expired = self.coupon(starts_at=past.isoformat(), expires_at=(past + timedelta(days=1)).isoformat())
        min_spend = self.coupon(min_order_amount="1000")
        once = self.coupon(discount_type="PERCENT", discount_value="10", usage_limit_total=1)
        self.assertEqual(self.b1.api("PUT", f"/api/cart/{p['product_id']}", {"qty": 2})[0], 200)
        for c, msg in ((expired, "expired"), (min_spend, "at least"), ({"code": "NOPE999"}, "does not exist")):
            st, q = self.b1.api("POST", "/api/checkout/quote", {"shop_id": self.shop_a, "coupon": c["code"]})
            self.assertEqual((st, q["coupon"]["ok"], q["discount"]), (200, False, 0))
            self.assertIn(msg, q["coupon"]["message"])
            st, out = self.b1.api("POST", "/api/checkout", {"shop_id": self.shop_a, "coupon": c["code"], **ADDR})
            self.assertEqual(st, 400, out)
            self.assertIn(msg, out["detail"])
        o = self.buy(self.b1, p["product_id"], qty=2, coupon=once["code"])  # 200 - 10% = 180 + 40 shipping
        self.assertEqual((D(o["subtotal"]), D(o["discount"]), D(o["shipping_fee"]), D(o["total"])), (D(200), D(20), D(40), D(220)))
        st, out = self.b1.api("POST", "/api/checkout/quote", {"shop_id": self.shop_a, "coupon": once["code"]})
        self.assertEqual(st, 400, "cart for this shop is empty after checkout")
        self.assertEqual(self.b2.api("PUT", f"/api/cart/{p['product_id']}", {"qty": 1})[0], 200)
        st, out = self.b2.api("POST", "/api/checkout", {"shop_id": self.shop_a, "coupon": once["code"], **ADDR})
        self.assertEqual(st, 400)
        self.assertIn("fully used", out["detail"])
        # tampering: totals from the browser are ignored (no such fields), prices come from the database
        st, o2 = self.b2.api("POST", "/api/checkout", {"shop_id": self.shop_a, "total": "1", "subtotal": "1", **ADDR})
        self.assertEqual(st, 201, o2)
        self.orders.append(o2["order_id"])
        self.assertEqual(D(o2["total"]), D(140))
        # cancelling the unpaid order gives the coupon use and the stock back
        before = self.stock(p["product_id"])
        st, c = self.b1.api("POST", f"/api/orders/{o['order_id']}/cancel", {"reason": "changed my mind"})
        self.assertEqual((st, c["status"]), (200, "CANCELLED"))
        self.assertEqual(self.stock(p["product_id"]), before + 2)
        self.assertEqual(svc("GET", f"coupon_redemptions?select=redemption_id&coupon_id=eq.{once['coupon_id']}"), [])

    # ------------------------------------------------------------ done-when 4: shipping timeline, slips, refund
    def test_slip_ship_deliver_timeline_and_refund(self):
        p = self.product(stock=5, price="300.00")
        o = self.buy(self.b1, p["product_id"], qty=2)
        self.assertEqual(self.sa.api("POST", f"/api/seller/orders/{o['order_id']}/ship", {"carrier": "Kerry", "tracking_number": "KER123456"})[0], 409,
                         "cannot ship before payment")
        paid, ref, path = self.pay(self.b1, o)
        # the same transfer slip cannot pay another order
        o2 = self.buy(self.b2, p["product_id"], qty=1)
        st, _ = http("POST", f"{URL}/storage/v1/object/payment-slips/{self.b2.uid}/{o2['order_id']}/x.png",
                     {"apikey": ANON, "Authorization": f"Bearer {self.b2.token}"}, raw=b"\x89PNG0000", ctype="image/png")
        self.assertEqual(st, 200)
        self.files.append(f"{self.b2.uid}/{o2['order_id']}/x.png")
        st, dup = self.b2.api("POST", f"/api/orders/{o2['order_id']}/slip", {"trans_ref": ref, "amount": str(o2["total"]), "slip_path": f"{self.b2.uid}/{o2['order_id']}/x.png"})
        self.assertEqual(st, 409, dup)
        # storage: another buyer cannot read the slip, the seller can
        self.assertNotEqual(http("POST", f"{URL}/storage/v1/object/sign/payment-slips/{path}", {"apikey": ANON, "Authorization": f"Bearer {self.b2.token}"}, {"expiresIn": 60})[0], 200)
        self.assertEqual(http("POST", f"{URL}/storage/v1/object/sign/payment-slips/{path}", {"apikey": ANON, "Authorization": f"Bearer {self.sa.token}"}, {"expiresIn": 60})[0], 200)
        slip_id = paid["slips"][0]["slip_id"]
        self.assertEqual(self.sb.api("POST", f"/api/seller/slips/{slip_id}/review", {"approve": True})[0], 404, "other seller")
        st, s = self.sa.api("POST", f"/api/seller/slips/{slip_id}/review", {"approve": True})
        self.assertEqual((st, s["status"]), (200, "TO_SHIP"))
        st, s = self.sa.api("POST", f"/api/seller/orders/{o['order_id']}/ship", {"carrier": "Kerry Express", "tracking_number": "KEX0012345"})
        self.assertEqual((st, s["status"], s["tracking_number"]), (200, "SHIPPED", "KEX0012345"))
        st, s = self.b1.api("POST", f"/api/orders/{o['order_id']}/received")
        self.assertEqual((st, s["status"]), (200, "DELIVERED"))
        timeline = self.b1.api("GET", f"/api/orders/{o['order_id']}")[1]["events"]
        self.assertEqual([e["status"] for e in timeline], ["PENDING_PAYMENT", "PENDING_PAYMENT", "TO_SHIP", "SHIPPED", "DELIVERED"])
        self.assertIn("KEX0012345", timeline[3]["note"])
        self.assertEqual(self.sa.api("GET", f"/api/orders/{o['order_id']}")[1]["events"], timeline, "seller and buyer see the same timeline")
        # refund after delivery: seller approves, no restock (goods were shipped)
        before = self.stock(p["product_id"])
        st, r = self.b1.api("POST", f"/api/orders/{o['order_id']}/refund", {"reason": "Item arrived broken"})
        self.assertEqual(st, 201, r)
        self.assertEqual(self.b1.api("POST", f"/api/orders/{o['order_id']}/refund", {"reason": "again"})[0], 409)
        st, r = self.sa.api("POST", f"/api/seller/refunds/{r['refunds'][0]['refund_id']}/decision", {"approve": True, "note": "Sorry"})
        self.assertEqual((st, r["status"]), (200, "REFUNDED"))
        self.assertEqual(self.stock(p["product_id"]), before)
        # seller accounting: the refund shows and the net payout follows the formula
        led = self.sa.api("GET", "/api/seller/ledger")[1]
        row = next(x for x in led["orders"] if x["order_id"] == o["order_id"])
        self.assertEqual(D(row["platform_fee"]), D("30.00"))  # 5% of 600
        self.assertEqual(D(row["net_payout"]), D(row["subtotal"]) - D(row["shop_discount"]) + D(row["shipping_fee"]) - D(row["platform_fee"]) - D(row["refunded"]))

    # ------------------------------------------------------------ stock management
    def test_stock_alerts_and_adjustments(self):
        p = self.product(stock=6)
        st, out = self.sa.api("POST", f"/api/seller/products/{p['product_id']}/stock", {"change": -2, "reason": "ADJUST", "note": "damaged"})
        self.assertEqual((st, out["stock_qty"]), (200, 4))
        self.assertIn(p["product_id"], [x["product_id"] for x in self.sa.api("GET", "/api/seller/overview")[1]["low_stock"]])
        self.assertEqual(self.sa.api("POST", f"/api/seller/products/{p['product_id']}/stock", {"change": -10, "reason": "ADJUST"})[0], 400)
        self.assertEqual(self.sa.api("POST", f"/api/seller/products/{p['product_id']}/stock", {"change": -1, "reason": "RESTOCK"})[0], 400)
        st, out = self.sa.api("POST", f"/api/seller/products/{p['product_id']}/stock", {"change": 20, "reason": "RESTOCK"})
        self.assertEqual(out["stock_qty"], 24)
        self.assertNotIn(p["product_id"], [x["product_id"] for x in self.sa.api("GET", "/api/seller/overview")[1]["low_stock"]])

    # ------------------------------------------------------------ registration and bans
    def test_register_only_through_the_api_and_ban(self):
        email = f"t{uuid.uuid4().hex[:8]}@fdeshop-demo.com"
        st, _ = http("POST", f"{URL}/auth/v1/signup", {"apikey": ANON}, {"email": email, "password": "Abcdefgh123!"})
        self.assertNotEqual(st, 200, "direct Supabase sign-up is refused")
        st, out = http("POST", f"{API}/api/register", {}, {"email": email, "password": "Abcdefgh123!", "display_name": "Temp Seller",
                                                          "role": "seller", "shop_name": f"Temp {email[:6]}"})
        self.assertEqual(st, 201, out)
        try:
            st, tok = http("POST", f"{URL}/auth/v1/token?grant_type=password", {"apikey": ANON}, {"email": email, "password": "Abcdefgh123!"})
            me = http("GET", f"{API}/api/me", {"Authorization": f"Bearer {tok['access_token']}"})[1]
            self.assertEqual((me["role"], bool(me["shop"])), ("seller", True))
            self.assertEqual(http("POST", f"{API}/api/register", {}, {"email": email, "password": "Abcdefgh123!", "display_name": "Xx", "role": "buyer"})[0], 409)
            # admin bans: every call refused at once, even with a token issued before the ban
            st, b = self.admin.api("POST", f"/api/admin/users/{out['user_id']}/ban", {"banned": True, "reason": "test"})
            self.assertEqual((st, b["status"]), (200, "banned"))
            self.assertEqual(http("GET", f"{API}/api/seller/products", {"Authorization": f"Bearer {tok['access_token']}"})[0], 403)
            self.assertEqual(http("POST", f"{URL}/rest/v1/rpc/seller_products", {"apikey": ANON, "Authorization": f"Bearer {tok['access_token']}"}, {})[0], 403)
            self.assertNotEqual(http("POST", f"{URL}/auth/v1/token?grant_type=password", {"apikey": ANON}, {"email": email, "password": "Abcdefgh123!"})[0], 200)
            self.assertEqual(self.b1.api("POST", f"/api/admin/users/{out['user_id']}/ban", {"banned": False})[0], 403)
        finally:
            http("DELETE", f"{URL}/auth/v1/admin/users/{out['user_id']}", SVC_H)

    def test_admin_overview_ranks_shops(self):
        st, ov = self.admin.api("GET", "/api/admin/overview")
        self.assertEqual(st, 200, ov)
        sales = [D(s["sales"]) for s in ov["top_shops"]]
        self.assertEqual(sales, sorted(sales, reverse=True))
        self.assertEqual(self.b1.api("GET", "/api/admin/overview")[0], 403)


if __name__ == "__main__":
    unittest.main()
