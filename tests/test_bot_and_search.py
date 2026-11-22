"""Offline unit tests for FDE Shop's large catalog, MarketBrain-style Smart Search, and Hybrid Sales Bot.

Run with:
  uv run python -m unittest tests.test_bot_and_search -v
"""
from __future__ import annotations

import sys
import unittest
from decimal import Decimal
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))
sys.path.insert(0, str(ROOT / "scripts"))

import catalog_data  # noqa: E402
from shop_api import app as shop_app, bot, smart_search  # noqa: E402


def build_offline_snapshot() -> dict:
    """Build a realistic in-memory snapshot matching public.bot_catalog_snapshot()."""
    categories = []
    cat_by_name = {}
    parent_by_child = {}
    cid = 1
    for name, name_th, slug, icon, sort_order, children in catalog_data.CATEGORY_TREE:
        parent_row = {
            "category_id": cid,
            "name": name,
            "name_th": name_th,
            "parent_id": None,
            "slug": slug,
            "icon": icon,
            "sort_order": sort_order,
        }
        categories.append(parent_row)
        cat_by_name[name] = parent_row
        parent_id = cid
        cid += 1
        for cidx, (cname, cname_th, cslug, cicon) in enumerate(children, start=1):
            child_row = {
                "category_id": cid,
                "name": cname,
                "name_th": cname_th,
                "parent_id": parent_id,
                "slug": cslug,
                "icon": cicon,
                "sort_order": sort_order * 10 + cidx,
            }
            categories.append(child_row)
            cat_by_name[cname] = child_row
            parent_by_child[cname] = parent_row
            cid += 1

    shop_map = {}
    sid = 1
    for acc in catalog_data.ACCOUNTS:
        if acc[3] == "seller":
            shop_map[acc[0]] = {"shop_id": sid, "name": acc[4]}
            sid += 1

    products = []
    for rec in catalog_data.build_product_records():
        c = cat_by_name[rec["category"]]
        pc = parent_by_child.get(rec["category"])
        sh = shop_map[rec["seller"]]
        price = Decimal(str(rec["price"]))
        unit_price = (price / Decimal(max(rec["pack_qty"], 1))).quantize(Decimal("0.01"))
        products.append({
            **rec,
            "price": float(price),
            "unit_price": float(unit_price),
            "category_id": c["category_id"],
            "category_th": c["name_th"],
            "parent_category_id": pc["category_id"] if pc else None,
            "parent_category": pc["name"] if pc else None,
            "parent_category_th": pc["name_th"] if pc else None,
            "shop_id": sh["shop_id"],
            "shop": sh["name"],
            "sold": 10 if "bestseller" in rec["tags"] else 2,
        })

    coupons = [
        {
            "code": "MEGA50",
            "shop_id": None,
            "shop": None,
            "platform": True,
            "discount_type": "FIXED",
            "discount_value": 50,
            "max_discount": None,
            "min_order_amount": 500,
            "expires_at": "2027-01-01T00:00:00Z",
        },
        *[
            {
                "code": code,
                "shop_id": shop_map[seller]["shop_id"],
                "shop": shop_map[seller]["name"],
                "platform": False,
                "discount_type": dtype,
                "discount_value": dval,
                "max_discount": max_d,
                "min_order_amount": min_amt,
                "expires_at": "2027-01-01T00:00:00Z",
            }
            for seller, code, dtype, dval, max_d, min_amt, _, _ in catalog_data.SHOP_COUPONS
        ],
    ]
    return {"products": products, "categories": categories, "coupons": coupons}


SNAPSHOT = build_offline_snapshot()


class CatalogDatasetTests(unittest.TestCase):
    def test_dataset_scale_and_integrity(self):
        records = catalog_data.build_product_records()
        self.assertGreaterEqual(len(records), 180, "Expected at least 180 rich products")
        self.assertEqual(len(catalog_data.CATEGORY_TREE), 12)
        sub_count = sum(len(c[5]) for c in catalog_data.CATEGORY_TREE)
        self.assertEqual(sub_count, 36)

        cat_names = {c[0] for c in catalog_data.CATEGORY_TREE}
        for c in catalog_data.CATEGORY_TREE:
            for sc in c[5]:
                cat_names.add(sc[0])
        skus = set()
        barcodes = set()
        for r in records:
            self.assertIn(r["category"], cat_names, f"Unknown category {r['category']} on {r['name']}")
            self.assertGreater(r["price"], 0)
            self.assertGreaterEqual(r["pack_qty"], 1)
            self.assertTrue(r["image_url"] is None or r["image_url"].startswith("https://"))
            self.assertNotIn(r["sku"], skus)
            self.assertNotIn(r["barcode"], barcodes)
            skus.add(r["sku"])
            barcodes.add(r["barcode"])


class SmartSearchTests(unittest.TestCase):
    def test_parse_budget_exclusion_sort_and_negation_guard(self):
        p = smart_search.parse_smart_query("น้ำปลา -ทิพรส ไม่ใส่ผงชูรส ไม่เกิน 200 ราคาถูกสุด")
        self.assertEqual(p.max_price, Decimal("200.00"))
        self.assertIn("ทิพรส", p.exclude_terms)
        # Negation guard: "ไม่ใส่ผงชูรส" must become trait `no_msg`, NOT an exclusion!
        self.assertIn("no_msg", p.inferred_tags)
        self.assertNotIn("ผงชูรส", p.exclude_terms)
        self.assertEqual(p.inferred_sort, "price_asc")

    def test_bilingual_thai_english_search(self):
        hits_en, _ = smart_search.search_snapshot_products(SNAPSHOT["products"], "fish sauce")
        self.assertTrue(any("น้ำปลา" in h["name"] for h in hits_en))

        hits_drill, _ = smart_search.search_snapshot_products(SNAPSHOT["products"], "สว่านมากิต้า งบ 3500")
        self.assertTrue(hits_drill)
        self.assertEqual(hits_drill[0]["brand"], "Makita")
        self.assertLessEqual(Decimal(str(hits_drill[0]["price"])), Decimal("3500"))

        hits_cat, _ = smart_search.search_snapshot_products(SNAPSHOT["products"], "cat food")
        self.assertTrue(any("แมว" in h["name"] for h in hits_cat))

    def test_exclusion_and_dietary_tags(self):
        hits, _ = smart_search.search_snapshot_products(SNAPSHOT["products"], "น้ำปลา -ทิพรส ฮาลาล ไม่ใส่ผงชูรส")
        self.assertTrue(hits)
        for h in hits:
            self.assertNotIn("ทิพรส", h["name"])
            self.assertIn("halal", h["tags"])
            self.assertIn("no_msg", h["tags"])

    def test_barcode_lookup(self):
        first = SNAPSHOT["products"][0]
        hits, parsed = smart_search.search_snapshot_products(SNAPSHOT["products"], first["barcode"])
        self.assertEqual(parsed.barcodes, [first["barcode"]])
        self.assertEqual(len(hits), 1)
        self.assertEqual(hits[0]["product_id"], first["product_id"])


class SalesBotTests(unittest.TestCase):
    def test_greeting_and_categories(self):
        res = bot.run_sales_bot_turn(message="สวัสดีครับ", snapshot=SNAPSHOT)
        self.assertEqual(res["stage_mode"], "gallery")
        self.assertTrue(res["products"])
        self.assertIn("น้องเอฟดี", res["reply"])

        cat_res = bot.run_sales_bot_turn(message="มีหมวดหมู่อะไรบ้าง", snapshot=SNAPSHOT)
        self.assertIn("12 หมวดหมู่หลัก", cat_res["reply"])

    def test_search_compare_and_numbered_cart_flow(self):
        # 1. Search
        s_res = bot.run_sales_bot_turn(message="สว่านไร้สาย งบ 3500", snapshot=SNAPSHOT)
        self.assertGreaterEqual(len(s_res["products"]), 2)
        focus_ids = [p["product_id"] for p in s_res["products"]]

        # 2. Compare #1 vs #2
        cmp_res = bot.run_sales_bot_turn(
            message="เปรียบเทียบเบอร์ 1 กับ 2",
            snapshot=SNAPSHOT,
            focus_product_ids=focus_ids,
        )
        self.assertEqual(cmp_res["stage_mode"], "compare")
        self.assertEqual(len(cmp_res["compare_products"]), 2)

        # 3. Numbered add-to-cart with real buyer_ops mock
        cart_state: dict[int, int] = {}

        def fake_cart_get():
            items = []
            for pid, qty in cart_state.items():
                p = next(x for x in SNAPSHOT["products"] if x["product_id"] == pid)
                sub = round(p["price"] * qty, 2)
                items.append({
                    "shop_id": p["shop_id"],
                    "shop": p["shop"],
                    "subtotal": sub,
                    "discount": 0,
                    "shipping_fee": 0 if sub >= 500 else 40,
                    "total": sub + (0 if sub >= 500 else 40),
                    "coupon": None,
                    "items": [{"product_id": pid, "name": p["name"], "unit_price": p["price"], "qty": qty, "line_total": sub, "stock_qty": p["stock_qty"], "available": True}],
                })
            return items

        def fake_cart_set(pid: int, qty: int):
            cart_state[pid] = qty
            return fake_cart_get()

        add_res = bot.run_sales_bot_turn(
            message="เอาเบอร์ 1 จำนวน 2 ชิ้น",
            snapshot=SNAPSHOT,
            focus_product_ids=focus_ids,
            buyer_ops={"cart_get": fake_cart_get, "cart_set": fake_cart_set},
        )
        self.assertEqual(add_res["stage_mode"], "cart")
        self.assertEqual(cart_state[focus_ids[0]], 2)
        self.assertTrue(any(a["type"] == "cart_added" and a["qty"] == 2 for a in add_res["actions"]))

    def test_coupons_intent(self):
        res = bot.run_sales_bot_turn(message="มีคูปองส่วนลดอะไรบ้าง", snapshot=SNAPSHOT)
        self.assertEqual(res["stage_mode"], "coupons")
        self.assertTrue(any(c["code"] == "MEGA50" for c in res["coupons"]))


class FastApiEndpointTests(unittest.TestCase):
    def setUp(self):
        bot.clear_snapshot_cache()
        self.req = SimpleNamespace(headers={}, state=SimpleNamespace())

    def test_bot_status_suggest_and_chat_endpoints(self):
        with patch.object(shop_app.supa, "rpc", return_value=SNAPSHOT):
            body = shop_app.bot_status(self.req)
            self.assertGreaterEqual(body["stats"]["products"], 180)
            self.assertEqual(body["stats"]["categories"], 12)

            sug = shop_app.catalog_suggest(self.req, q="makita", limit=8)
            self.assertTrue(any(p["brand"] == "Makita" for p in sug["products"]))

            chat_data = shop_app.bot_chat(shop_app.BotChatIn(message="อาหารฮาลาล ไม่เกิน 200"), self.req)
            self.assertTrue(chat_data["products"])
            self.assertTrue(all(p["price"] <= 200 for p in chat_data["products"]))

            # Also verify GET /api/catalog forwards parsed smart-search params cleanly to Supabase RPC
            captured = {}

            def capture_rpc(_req, name, params=None, **_kw):
                captured["name"] = name
                captured["params"] = params
                return {"total": 1, "categories": [], "items": []}

            with patch.object(shop_app.supa, "rpc", side_effect=capture_rpc):
                out = shop_app.catalog(
                    self.req,
                    q="น้ำปลา -ทิพรส ไม่เกิน 200 ราคาถูกสุด",
                    category_id=None,
                    shop_id=None,
                    brand=None,
                    min_price=None,
                    max_price=None,
                    tags=None,
                    in_stock=False,
                    exclude=None,
                    smart=True,
                    sort="new",
                    page=1,
                    page_size=24,
                )
            self.assertEqual(captured["name"], "catalog")
            self.assertEqual(captured["params"]["p_max_price"], "200.00")
            self.assertEqual(captured["params"]["p_sort"], "price_asc")
            self.assertIn("ทิพรส", captured["params"]["p_exclude"])
            self.assertTrue(out["parsed_hints"])


if __name__ == "__main__":
    unittest.main()
