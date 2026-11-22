"""Hybrid Sales Concierge Bot ("น้องเอฟดี" — inspired by MarketBrain's Javis/Nong Tee).

Architecture:
1. Grounded 100% in live Supabase data via `bot_catalog_snapshot()` (cached in RAM for 60s, zero PII).
2. Deterministic Fast-Path Engine works out-of-the-box WITHOUT any LLM API key:
   - Smart Thai/English search (budget, exclusions, dietary/trait tags, barcodes, synonyms)
   - Numbered/pointed add-to-cart commands ("เอาเบอร์ 1 2 ชิ้น", "หยิบตัวแรกใส่ตะกร้า") executing real `cart_set` RPC
   - Real server-side cart summary & coupon quoting (`cart_get` / `checkout_quote` RPC)
   - Side-by-side product comparison with Decimal unit-price math
   - Coupon & campaign discovery + free-shipping (฿500) coaching
3. Optional LLM Upgrade (DeepSeek / OpenAI-compatible / Gemini):
   - Auto-enabled when `LLM_API_KEY` (or `DEEPSEEK_API_KEY` / `OPENAI_API_KEY` / `GEMINI_API_KEY`) is set in `.env`.
   - Token-saver pattern: local retrieval & real cart actions happen FIRST; LLM only receives top 6 grounded products
     and synthesizes a warm, consultative sales response (with automatic fallback to deterministic reply on timeout/error).
"""
from __future__ import annotations

import json
import os
import re
import time
import urllib.error
import urllib.request
from decimal import Decimal, ROUND_HALF_UP
from typing import Any, Callable

from .smart_search import TAG_META, parse_smart_query, search_snapshot_products

# ------------------------------------------------------------------ Snapshot cache (60s TTL)
_CACHE: dict[str, Any] = {"at": 0.0, "data": None}
CACHE_TTL_SEC = 60.0


def get_cached_snapshot(fetcher: Callable[[], dict[str, Any]], *, force: bool = False) -> dict[str, Any]:
    now = time.monotonic()
    if not force and _CACHE["data"] is not None and (now - _CACHE["at"]) < CACHE_TTL_SEC:
        return _CACHE["data"]
    data = fetcher()
    _CACHE["data"] = data
    _CACHE["at"] = now
    return data


def clear_snapshot_cache() -> None:
    _CACHE["data"] = None
    _CACHE["at"] = 0.0


# ------------------------------------------------------------------ Money formatting (strict Decimal)
def fmt_baht(val: Any) -> str:
    d = Decimal(str(val or 0)).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
    return f"฿{d:,.0f}" if d == d.to_integral_value() else f"฿{d:,.2f}"


def _free_ship_gap(subtotal: Decimal) -> Decimal:
    gap = Decimal("500.00") - subtotal
    return gap if gap > 0 else Decimal("0.00")


# ------------------------------------------------------------------ Thai number & intent parsers
_THAI_NUMS: dict[str, int] = {
    "หนึ่ง": 1, "นึง": 1, "แรก": 1, "สอง": 2, "สาม": 3, "สี่": 4, "ห้า": 5,
    "หก": 6, "เจ็ด": 7, "แปด": 8, "เก้า": 9, "สิบ": 10,
}

_GREETING_RE = re.compile(r"^(?:สวัสดี|หวัดดี|ดีครับ|ดีค่ะ|ทัก|เริ่ม|ช่วยอะไรได้|ทำอะไรได้|hi|hello|hey|help|\?)+[\s!?.ครับค่ะ]*$", re.I)
_COUPON_INTENT_RE = re.compile(r"(?:คูปอง|โค้ดส่วนลด|โปรโมชั่?น|ส่วนลด|โค้ดลด|coupon|promo|discount|voucher)", re.I)
_CATEGORY_INTENT_RE = re.compile(r"(?:มีหมวด|หมวดหมู่|ขายอะไรบ้าง|มีอะไรขาย|ทั้งหมดกี่หมวด|categories|catalog overview)", re.I)
_CART_VIEW_RE = re.compile(r"(?:ดูตะกร้า|ตะกร้าสินค้า|สรุปยอด|เช็คบิล|ปิดบิล|ชำระเงิน|สั่งซื้อเลย|checkout|my cart|view cart)", re.I)
_COMPARE_RE = re.compile(r"(?:เปรียบเทียบ|เทียบราคา|เทียบสเปก|เทียบ\s*(?:เบอร์|ตัว|อัน|#)?\s*\d|ตัวไหนคุ้ม|อันไหนดี|compare)", re.I)
_ADD_CART_RE = re.compile(r"(?:เอา|หยิบ|ใส่ตะกร้า|เพิ่มลงตะกร้า|สั่ง|ซื้อ|add\s*to\s*cart|buy\s*#|add\s*#)", re.I)
_COUPON_CODE_RE = re.compile(r"\b([A-Z]{3,}[0-9]{1,4}|[A-Z0-9]{5,12})\b")
_QTY_RE = re.compile(r"(?:จำนวน\s*|x\s*)?(\d{1,2})\s*(?:ชิ้น|อัน|กล่อง|ขวด|แพ็ก|แพ็ค|ลัง|ถุง|ใบ|ตัว|เครื่อง|ชุด|คู่|ขวด|pcs?)?", re.I)


def _extract_card_indices(text: str) -> list[int]:
    """Extract 1-based card numbers like 'เบอร์ 1', '#2', 'ตัวแรก', 'อันที่ 3', '1 กับ 2'."""
    nums: list[int] = []
    if re.search(r"(?:ตัวแรก|อันแรก|ชิ้นแรก|รายการแรก|first\s*one)", text, re.I):
        nums.append(1)
    if re.search(r"(?:ตัวที่สอง|อันที่สอง|ชิ้นที่สอง)", text, re.I):
        nums.append(2)
    for m in re.finditer(r"(?:เบอร์|หมายเลข|ลำดับ|ตัวที่|อันที่|ชิ้นที่|รายการที่|#)\s*(\d{1,2})", text, re.I):
        n = int(m.group(1))
        if 1 <= n <= 20 and n not in nums:
            nums.append(n)
    # Pattern like "เทียบ 1 กับ 2" or "เปรียบเทียบ 1, 2, 3"
    if _COMPARE_RE.search(text) and len(nums) < 2:
        for m in re.finditer(r"(?<!\d)(\d{1,2})(?!\d)", text):
            n = int(m.group(1))
            if 1 <= n <= 20 and n not in nums:
                nums.append(n)
    return nums


def _extract_qty(text: str, index_nums: list[int]) -> int:
    """Extract desired quantity from an add-to-cart message, avoiding confusing the card index with qty."""
    cleaned = re.sub(r"(?:เบอร์|หมายเลข|ลำดับ|ตัวที่|อันที่|ชิ้นที่|รายการที่|#)\s*\d{1,2}", " ", text, flags=re.I)
    m = re.search(r"(?:จำนวน\s*)?(\d{1,2})\s*(?:ชิ้น|อัน|กล่อง|ขวด|แพ็ก|แพ็ค|ลัง|ถุง|ใบ|ตัว|เครื่อง|ชุด|คู่|กระปุก|ห่อ|pcs?)", cleaned, re.I)
    if m:
        return max(1, min(99, int(m.group(1))))
    m2 = re.search(r"(?:จำนวน|x|\*)\s*(\d{1,2})", cleaned, re.I)
    if m2:
        return max(1, min(99, int(m2.group(1))))
    for word, val in _THAI_NUMS.items():
        if re.search(rf"{word}\s*(?:ชิ้น|อัน|กล่อง|ขวด|แพ็ก|แพ็ค|ลัง|ถุง|ใบ|ตัว|เครื่อง|ชุด|คู่)", cleaned):
            return val
    # Standalone trailing number if not the index itself
    m3 = re.search(r"\s(\d{1,2})\s*(?:ครับ|ค่ะ|นะ)?$", cleaned)
    if m3:
        n = int(m3.group(1))
        if 1 <= n <= 99 and n not in index_nums:
            return n
    return 1


def _build_brain_path(query: str, products: list[dict[str, Any]]) -> dict[str, Any] | None:
    if not products:
        return None
    cats: list[str] = []
    brands: list[str] = []
    tags: list[str] = []
    for p in products[:6]:
        c = p.get("category_th") or p.get("category")
        if c and c not in cats and len(cats) < 3:
            cats.append(c)
        b = p.get("brand")
        if b and b not in brands and len(brands) < 3:
            brands.append(b)
        for t in (p.get("tags") or []):
            lbl = TAG_META.get(t, {}).get("label", t)
            if lbl not in tags and len(tags) < 3:
                tags.append(lbl)
    return {
        "query": query.strip()[:48] or "คลังสินค้า FDE Shop",
        "categories": cats,
        "brands": brands,
        "tags": tags,
        "top_products": [
            {"no": i + 1, "product_id": p["product_id"], "name": p["name"], "price": p["price"]}
            for i, p in enumerate(products[:4])
        ],
    }


def _matching_coupons(coupons: list[dict[str, Any]], products: list[dict[str, Any]]) -> list[dict[str, Any]]:
    shop_ids = {p.get("shop_id") for p in products}
    out = [c for c in coupons if c.get("platform") or c.get("shop_id") in shop_ids]
    return out[:4]


def _format_coupon_line(c: dict[str, Any]) -> str:
    disc = f"ลด {c['discount_value']}%" if c["discount_type"] == "PERCENT" else f"ลด {fmt_baht(c['discount_value'])}"
    if c.get("max_discount"):
        disc += f" (สูงสุด {fmt_baht(c['max_discount'])})"
    min_amt = Decimal(str(c.get("min_order_amount") or 0))
    cond = f" ขั้นต่ำ {fmt_baht(min_amt)}" if min_amt > 0 else ""
    scope = "ทั้งแพลตฟอร์ม" if c.get("platform") else f"ร้าน {c.get('shop') or ''}"
    return f"โค้ด `{c['code']}` {disc}{cond} ({scope})"


# ------------------------------------------------------------------ Optional LLM Provider (Hybrid Mode)
def detect_llm_config() -> dict[str, str] | None:
    """Detect optional OpenAI-compatible LLM config from env vars (never logs keys)."""
    api_key = (
        os.environ.get("LLM_API_KEY")
        or os.environ.get("DEEPSEEK_API_KEY")
        or os.environ.get("OPENAI_API_KEY")
        or os.environ.get("GEMINI_API_KEY")
        or ""
    ).strip()
    if not api_key:
        return None
    base_url = os.environ.get("LLM_BASE_URL", "").strip().rstrip("/")
    model = os.environ.get("LLM_MODEL", "").strip()
    if not base_url:
        if os.environ.get("DEEPSEEK_API_KEY") and not os.environ.get("LLM_API_KEY"):
            base_url = "https://api.deepseek.com/v1"
            model = model or "deepseek-chat"
        elif os.environ.get("GEMINI_API_KEY") and not os.environ.get("LLM_API_KEY"):
            base_url = "https://generativelanguage.googleapis.com/v1beta/openai"
            model = model or "gemini-2.5-flash"
        else:
            base_url = "https://api.openai.com/v1"
            model = model or "gpt-4o-mini"
    else:
        model = model or "deepseek-chat"
    return {"api_key": api_key, "base_url": base_url, "model": model}


def _call_llm_polish(
    cfg: dict[str, str],
    user_message: str,
    history: list[dict[str, str]],
    grounded_products: list[dict[str, Any]],
    coupons: list[dict[str, Any]],
    fallback_reply: str,
) -> str | None:
    """Use optional LLM to craft a natural Thai/English sales reply strictly grounded in real DB products."""
    if not grounded_products:
        return None
    lines = []
    for idx, p in enumerate(grounded_products[:6], start=1):
        pack_txt = (
            f" ({p.get('unit')}, เฉลี่ย {fmt_baht(p.get('unit_price'))}/หน่วย)"
            if int(p.get("pack_qty") or 1) > 1
            else f" ({p.get('unit') or 'ชิ้น'})"
        )
        tag_txt = ", ".join(TAG_META.get(t, {}).get("label", t) for t in (p.get("tags") or [])[:4])
        lines.append(
            f"#{idx} {p['name']} | แบรนด์:{p.get('brand') or '-'} | ราคา:{fmt_baht(p['price'])}{pack_txt} "
            f"| คงเหลือ:{p.get('stock_qty', 0)} | ร้าน:{p.get('shop')} | จุดเด่น:{tag_txt or '-'}"
        )
    cpn_lines = [_format_coupon_line(c) for c in coupons[:3]]
    system_prompt = (
        "คุณคือ 'น้องเอฟดี' (FDE Sales Concierge) พนักงานขายและผู้ช่วยค้นหาสินค้ามืออาชีพของตลาด FDE Shop "
        "พูดสุภาพ เป็นกันเอง กระชับ (ลงท้าย ครับ/นะครับ) ห้ามเดาราคาหรือแต่งชื่อสินค้าเองเด็ดขาด "
        "ให้อ้างอิงเฉพาะรายการสินค้าจริงด้านล่าง โดยระบุเลขเบอร์ #1, #2... ให้ลูกค้าสั่งหยิบใส่ตะกร้าได้ง่าย "
        "ตอบสั้นกระชับ 3-5 บรรทัด พร้อมแนะนำความคุ้มค่า คูปอง หรือเกณฑ์ส่งฟรีเมื่อครบ ฿500\n\n"
        "สินค้าที่ค้นพบจากคลังจริง:\n" + "\n".join(lines) +
        ("\n\nคูปองที่ใช้ได้:\n" + "\n".join(cpn_lines) if cpn_lines else "")
    )
    msgs = [{"role": "system", "content": system_prompt}]
    for h in history[-4:]:
        if h.get("role") in ("user", "assistant") and h.get("content"):
            msgs.append({"role": h["role"], "content": str(h["content"])[:240]})
    msgs.append({"role": "user", "content": user_message[:400]})

    payload = {
        "model": cfg["model"],
        "messages": msgs,
        "temperature": 0.4,
        "max_tokens": 380,
    }
    req = urllib.request.Request(
        f"{cfg['base_url']}/chat/completions",
        data=json.dumps(payload).encode("utf-8"),
        method="POST",
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {cfg['api_key']}",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=12) as resp:
            data = json.loads(resp.read().decode("utf-8"))
        content = data["choices"][0]["message"]["content"]
        # Strip any accidental reasoning tags
        content = re.sub(r"<think>[\s\S]*?</think>", "", content, flags=re.I).strip()
        return content or fallback_reply
    except (urllib.error.URLError, KeyError, ValueError, TimeoutError):
        return None


# ------------------------------------------------------------------ Main Turn Runner
def run_sales_bot_turn(
    *,
    message: str,
    snapshot: dict[str, Any],
    history: list[dict[str, str]] | None = None,
    focus_product_ids: list[int] | None = None,
    viewing_product_id: int | None = None,
    dietary_tags: list[str] | None = None,
    buyer_ops: dict[str, Callable[..., Any]] | None = None,
) -> dict[str, Any]:
    """Execute one sales concierge turn and return structured reply + visual stage payload.

    `buyer_ops` (only supplied when caller is authenticated as a buyer):
      - `cart_get()`: returns list of shop cart groups from DB
      - `cart_set(product_id, qty)`: sets qty in DB and returns updated cart groups
      - `checkout_quote(shop_id, coupon)`: returns server-priced quote with coupon verification
    """
    msg = (message or "").strip()
    history = history or []
    products: list[dict[str, Any]] = snapshot.get("products") or []
    categories: list[dict[str, Any]] = snapshot.get("categories") or []
    coupons: list[dict[str, Any]] = snapshot.get("coupons") or []
    by_id = {int(p["product_id"]): p for p in products}
    focus_products = [by_id[pid] for pid in (focus_product_ids or []) if pid in by_id]
    viewing_product = by_id.get(viewing_product_id) if viewing_product_id else None
    active_dietary = [t for t in (dietary_tags or []) if t in TAG_META]
    actions: list[dict[str, Any]] = []

    # 1. Greeting / Help
    if _GREETING_RE.match(msg):
        main_cats = [c for c in categories if not c.get("parent_id")]
        cat_preview = " · ".join(f"{c.get('icon') or ''} {c.get('name_th') or c['name']}" for c in main_cats[:6])
        top_picks = [p for p in products if "bestseller" in (p.get("tags") or []) and int(p.get("stock_qty") or 0) > 0][:8]
        if not top_picks:
            top_picks = products[:8]
        reply = (
            f"สวัสดีครับ! ผม **น้องเอฟดี** ผู้ช่วยค้นหาและปิดการขายของ FDE Shop ครับ 👋\n"
            f"ตอนนี้ในคลังมีสินค้าพร้อมช้อป **{len(products):,} รายการ** ครอบคลุม **{len(main_cats)} หมวดหมู่หลัก** ({cat_preview}...)\n"
            f"บอกได้เลยครับว่าอยากหาอะไร งบเท่าไหร่ เช่น *\"สว่านมากิต้า งบ 3500\"*, *\"อาหารฮาลาล ไม่ใส่ผงชูรส ไม่เกิน 200\"* "
            f"หรือสั่ง *\"เอาเบอร์ 1 จำนวน 2 ชิ้น\"* เพื่อหยิบใส่ตะกร้าทันทีครับ!"
        )
        return {
            "reply": reply,
            "engine": "smart-fastpath",
            "stage_mode": "gallery",
            "parsed_hints": [],
            "products": top_picks,
            "compare_products": [],
            "coupons": coupons[:4],
            "cart": None,
            "actions": actions,
            "suggestions": [
                "อาหารฮาลาล ไร้ผงชูรส ไม่เกิน 200",
                "สว่านไร้สาย งบ 3500",
                "หูฟังไร้สาย ราคาถูกสุด",
                "มีคูปองส่วนลดอะไรบ้าง",
            ],
            "brain_path": _build_brain_path("สินค้าขายดีแนะนำ", top_picks),
        }

    # 2. Category overview
    if _CATEGORY_INTENT_RE.search(msg):
        main_cats = [c for c in categories if not c.get("parent_id")]
        counts: dict[int, int] = {}
        for p in products:
            cid = p.get("parent_category_id") or p.get("category_id")
            if cid:
                counts[int(cid)] = counts.get(int(cid), 0) + 1
        cat_lines = [
            f"- {c.get('icon') or '•'} **{c.get('name_th') or c['name']}** ({c['name']}) — {counts.get(int(c['category_id']), 0)} รายการ"
            for c in main_cats
        ]
        top_picks = [p for p in products if "bestseller" in (p.get("tags") or [])][:8]
        reply = (
            f"ตอนนี้ FDE Shop มีทั้งหมด **{len(main_cats)} หมวดหมู่หลัก** ({len(products):,} สินค้า) ครับ:\n"
            + "\n".join(cat_lines[:12])
            + "\n\nสนใจหมวดไหนพิมพ์บอกน้องเอฟดีได้เลยครับ เดี๋ยวคัดตัวคุ้มๆ ให้!"
        )
        return {
            "reply": reply,
            "engine": "smart-fastpath",
            "stage_mode": "gallery",
            "parsed_hints": [f"{len(main_cats)} หมวดหมู่หลัก"],
            "products": top_picks,
            "compare_products": [],
            "coupons": coupons[:4],
            "cart": None,
            "actions": actions,
            "suggestions": ["อาหารและเครื่องดื่ม แพ็กคุ้ม", "เครื่องมือช่าง มอก.", "อาหารแมว ขายดี", "ดูคูปองทั้งหมด"],
            "brain_path": _build_brain_path("หมวดหมู่ทั้งหมด", top_picks),
        }

    # 3. Numbered / Pointed Add-to-Cart ("เอาเบอร์ 1 2 ชิ้น", "หยิบตัวแรกใส่ตะกร้า", "ใส่ตะกร้าเลย")
    card_indices = _extract_card_indices(msg)
    wants_add = bool(_ADD_CART_RE.search(msg)) and not bool(_COMPARE_RE.search(msg)) and not bool(_CART_VIEW_RE.search(msg))
    if wants_add and (card_indices or viewing_product or (len(focus_products) == 1 and re.search(r"(?:ตัวนี้|อันนี้|ชิ้นนี้|ใส่ตะกร้า)", msg))):
        target: dict[str, Any] | None = None
        if card_indices:
            idx = card_indices[0] - 1
            if 0 <= idx < len(focus_products):
                target = focus_products[idx]
        elif viewing_product:
            target = viewing_product
        elif len(focus_products) == 1:
            target = focus_products[0]

        if target is not None:
            qty = _extract_qty(msg, card_indices)
            stock = int(target.get("stock_qty") or 0)
            if stock <= 0:
                return {
                    "reply": f"ขออภัยครับ **{target['name']}** ตอนนี้สินค้าหมดสต็อกครับ น้องเอฟดีช่วยหาสินค้ารุ่นใกล้เคียงในหมวดเดียวกันให้ไหมครับ?",
                    "engine": "smart-fastpath",
                    "stage_mode": "detail",
                    "parsed_hints": ["สินค้าหมด"],
                    "products": [target],
                    "compare_products": [],
                    "coupons": _matching_coupons(coupons, [target]),
                    "cart": None,
                    "actions": [],
                    "suggestions": [f"หาสินค้าคล้าย {target.get('category_th') or target.get('category') or ''}"],
                    "brain_path": _build_brain_path(msg, [target]),
                }
            if qty > stock:
                qty = stock

            if buyer_ops is None:
                return {
                    "reply": (
                        f"รับทราบครับ! คุณต้องการ **{target['name']}** จำนวน **{qty} {target.get('unit') or 'ชิ้น'}** "
                        f"(ราคาชิ้นละ {fmt_baht(target['price'])})\n"
                        f"กรุณา **เข้าสู่ระบบด้วยบัญชีผู้ซื้อ (Buyer)** ก่อนนะครับ แล้วกดปุ่ม *ใส่ตะกร้า* หรือสั่งน้องเอฟดีใหม่อีกครั้ง ผมจะหยิบลงตะกร้าจริงให้ทันทีครับ!"
                    ),
                    "engine": "smart-fastpath",
                    "stage_mode": "detail",
                    "parsed_hints": [f"ต้องการ {qty} {target.get('unit') or 'ชิ้น'}"],
                    "products": [target],
                    "compare_products": [],
                    "coupons": _matching_coupons(coupons, [target]),
                    "cart": None,
                    "actions": [{"type": "login_required", "product_id": target["product_id"], "qty": qty}],
                    "suggestions": ["ดูคูปองส่วนลด", "เปรียบเทียบกับตัวอื่น"],
                    "brain_path": _build_brain_path(target["name"], [target]),
                }

            # Real DB write via buyer cart_set RPC (add to existing qty if already in cart)
            existing_qty = 0
            try:
                current_cart = buyer_ops["cart_get"]() or []
                for grp in current_cart:
                    for it in grp.get("items") or []:
                        if int(it["product_id"]) == int(target["product_id"]):
                            existing_qty = int(it["qty"])
                new_qty = min(99, stock, existing_qty + qty)
                updated_cart = buyer_ops["cart_set"](int(target["product_id"]), new_qty)
            except Exception as exc:  # noqa: BLE001
                return {
                    "reply": f"ไม่สามารถเพิ่ม **{target['name']}** ลงตะกร้าได้ครับ: {exc}",
                    "engine": "smart-fastpath",
                    "stage_mode": "detail",
                    "parsed_hints": [],
                    "products": [target],
                    "compare_products": [],
                    "coupons": _matching_coupons(coupons, [target]),
                    "cart": None,
                    "actions": [],
                    "suggestions": ["ดูตะกร้าสินค้า"],
                    "brain_path": _build_brain_path(target["name"], [target]),
                }

            actions.append({
                "type": "cart_added",
                "product_id": target["product_id"],
                "name": target["name"],
                "qty": new_qty,
                "added_qty": qty,
            })
            # Compute server-backed shop summary
            shop_grp = next((g for g in updated_cart if int(g["shop_id"]) == int(target["shop_id"])), None)
            ship_hint = ""
            if shop_grp:
                sub = Decimal(str(shop_grp["subtotal"]))
                gap = _free_ship_gap(sub)
                if gap > 0:
                    ship_hint = f"\nยอดร้าน **{shop_grp['shop']}** ตอนนี้ {fmt_baht(sub)} (เพิ่มอีก {fmt_baht(gap)} ได้ส่งฟรี ฿40 ครับ!)"
                else:
                    ship_hint = f"\nยอดร้าน **{shop_grp['shop']}** ตอนนี้ {fmt_baht(sub)} — **ได้สิทธิ์ส่งฟรีแล้วครับ!** 🎉"
            rel_coupons = _matching_coupons(coupons, [target])
            cpn_hint = f"\n💡 ลองใช้ {_format_coupon_line(rel_coupons[0])}" if rel_coupons else ""
            reply = (
                f"หยิบ **{target['name']}** จำนวน **{qty} {target.get('unit') or 'ชิ้น'}** ใส่ตะกร้าให้เรียบร้อยแล้วครับ! "
                f"(รวมในตะกร้า {new_qty} {target.get('unit') or 'ชิ้น'}){ship_hint}{cpn_hint}\n"
                f"ต้องการหาอะไรเพิ่ม หรือพิมพ์ *\"ดูตะกร้า\"* เพื่อไปหน้าชำระเงินได้เลยครับ"
            )
            return {
                "reply": reply,
                "engine": "smart-fastpath",
                "stage_mode": "cart",
                "parsed_hints": [f"เพิ่มลงตะกร้า +{qty}"],
                "products": focus_products or [target],
                "compare_products": [],
                "coupons": rel_coupons,
                "cart": updated_cart,
                "actions": actions,
                "suggestions": ["ดูตะกร้าสินค้า", "มีคูปองลดเพิ่มไหม", "หาสินค้าขายดีเพิ่มให้ครบส่งฟรี"],
                "brain_path": _build_brain_path(target["name"], [target]),
            }

    # 4. View Cart / Quote Coupon / Checkout
    if _CART_VIEW_RE.search(msg):
        if buyer_ops is None:
            return {
                "reply": "กรุณา **เข้าสู่ระบบด้วยบัญชีผู้ซื้อ (Buyer)** เพื่อดูตะกร้าสินค้า เช็คคูปอง และปิดบิลคำสั่งซื้อครับ",
                "engine": "smart-fastpath",
                "stage_mode": "cart",
                "parsed_hints": ["ต้องเข้าสู่ระบบ"],
                "products": focus_products,
                "compare_products": [],
                "coupons": coupons[:4],
                "cart": [],
                "actions": [{"type": "login_required"}],
                "suggestions": ["ดูสินค้าขายดี", "มีคูปองอะไรบ้าง"],
                "brain_path": None,
            }
        cart_groups = buyer_ops["cart_get"]() or []
        if not cart_groups:
            return {
                "reply": "ตะกร้าของคุณยังว่างอยู่ครับ อยากให้น้องเอฟดีช่วยหาสินค้าหมวดไหนบอกได้เลยครับ!",
                "engine": "smart-fastpath",
                "stage_mode": "cart",
                "parsed_hints": ["ตะกร้าว่าง"],
                "products": focus_products,
                "compare_products": [],
                "coupons": coupons[:4],
                "cart": [],
                "actions": [],
                "suggestions": ["อาหารฮาลาล ไม่เกิน 200", "อุปกรณ์ชาร์จเร็ว", "สินค้าขายดี"],
                "brain_path": None,
            }
        # If user mentioned a coupon code, quote it via server RPC!
        code_m = _COUPON_CODE_RE.search(msg.upper())
        coupon_note = ""
        if code_m and "checkout_quote" in buyer_ops:
            code = code_m.group(1)
            quoted = []
            for g in cart_groups:
                try:
                    q = buyer_ops["checkout_quote"](int(g["shop_id"]), code)
                    quoted.append(q)
                    if q.get("coupon", {}).get("ok"):
                        coupon_note += f"\n🎟️ โค้ด `{code}` ใช้กับร้าน **{q['shop']}** ลดได้ **{fmt_baht(q['discount'])}** ยอดสุทธิ **{fmt_baht(q['total'])}**!"
                    else:
                        coupon_note += f"\n⚠️ โค้ด `{code}` กับร้าน {q['shop']}: {q.get('coupon', {}).get('message', 'ใช้ไม่ได้')}"
                except Exception:  # noqa: BLE001
                    quoted.append(g)
            cart_groups = quoted

        lines = []
        grand_total = Decimal("0.00")
        for g in cart_groups:
            sub = Decimal(str(g["subtotal"]))
            tot = Decimal(str(g["total"]))
            grand_total += tot
            gap = _free_ship_gap(sub)
            ship_txt = "ส่งฟรี" if Decimal(str(g["shipping_fee"])) == 0 else f"ค่าส่ง {fmt_baht(g['shipping_fee'])} (อีก {fmt_baht(gap)} ส่งฟรี)"
            lines.append(f"- **{g['shop']}** ({len(g['items'])} รายการ): ยอดรวม **{fmt_baht(tot)}** ({ship_txt})")
        reply = (
            "สรุปตะกร้าสินค้าล่าสุด (คำนวณราคาจริงจากเซิร์ฟเวอร์ครับ):\n"
            + "\n".join(lines)
            + f"\n**รวมทั้งหมด {fmt_baht(grand_total)}**{coupon_note}\n"
            + "กดปุ่ม **ไปหน้าชำระเงิน** บนเวทีด้านขวาเพื่อกรอกที่อยู่และยืนยันคำสั่งซื้อได้เลยครับ!"
        )
        return {
            "reply": reply,
            "engine": "smart-fastpath",
            "stage_mode": "cart",
            "parsed_hints": ["สรุปตะกร้าจริงจาก DB"],
            "products": focus_products,
            "compare_products": [],
            "coupons": coupons[:4],
            "cart": cart_groups,
            "actions": actions,
            "suggestions": ["ลองใช้คูปอง MEGA50", "มีคูปองร้านไหนอีกบ้าง"],
            "brain_path": None,
        }

    # 5. Coupon & Promotion Discovery (when not searching for a specific product)
    if _COUPON_INTENT_RE.search(msg) and not re.search(r"(?:หา|ซื้อ|เอา|สว่าน|น้ำปลา|กาแฟ|หูฟัง|แมว|หมา)", msg):
        if not coupons:
            reply = "ตอนนี้ยังไม่มีคูปองที่เปิดใช้งานครับ แต่สั่งครบ **฿500 ต่อร้าน** ได้สิทธิ์ **ส่งฟรีทันที** (ประหยัด ฿40) ครับ!"
        else:
            cpn_lines = [f"- {_format_coupon_line(c)}" for c in coupons[:8]]
            reply = (
                f"รวมคูปองส่วนลดที่ใช้ได้ตอนนี้ครับ ({len(coupons)} โค้ด):\n"
                + "\n".join(cpn_lines)
                + "\n\n🎁 พิเศษ: สั่งครบ **฿500 หลังหักส่วนลด** รับสิทธิ์ **ส่งฟรี** (ปกติ ฿40) ทุกออร์เดอร์ครับ!"
            )
        return {
            "reply": reply,
            "engine": "smart-fastpath",
            "stage_mode": "coupons",
            "parsed_hints": [f"พบ {len(coupons)} คูปอง"],
            "products": focus_products,
            "compare_products": [],
            "coupons": coupons,
            "cart": None,
            "actions": [],
            "suggestions": ["ดูสินค้าขายดี", "ดูตะกร้าสินค้า", "อาหารแพ็กคุ้มราคาส่ง"],
            "brain_path": None,
        }

    # 6. Product Comparison ("เปรียบเทียบ", "เทียบเบอร์ 1 กับ 2", "ตัวไหนคุ้มสุด")
    if _COMPARE_RE.search(msg):
        picks: list[dict[str, Any]] = []
        if card_indices and focus_products:
            for idx in card_indices[:4]:
                if 1 <= idx <= len(focus_products):
                    picks.append(focus_products[idx - 1])
        if len(picks) < 2:
            # Try searching if user wrote "เปรียบเทียบสว่านมากิต้ากับบ๊อช"
            stripped = _COMPARE_RE.sub(" ", msg).strip()
            if len(stripped) >= 2:
                found_cmp, _ = search_snapshot_products(products, stripped, tags=active_dietary or None, limit=4)
                if len(found_cmp) >= 2:
                    picks = found_cmp[:4]
        if len(picks) < 2 and len(focus_products) >= 2:
            picks = focus_products[:4]
        if len(picks) >= 2:
            cheapest = min(picks, key=lambda p: Decimal(str(p["price"])))
            best_unit = min(picks, key=lambda p: Decimal(str(p.get("unit_price") or p["price"])))
            reply = (
                f"น้องเอฟดีเทียบให้ดูชัดๆ **{len(picks)} รายการ** บนตารางด้านขวาแล้วครับ:\n"
                f"- 💰 **ราคาประหยัดสุด**: {cheapest['name']} ({fmt_baht(cheapest['price'])})\n"
                f"- 📦 **เฉลี่ยต่อหน่วยคุ้มสุด**: {best_unit['name']} ({fmt_baht(best_unit.get('unit_price') or best_unit['price'])}/หน่วย)\n"
                f"ถูกใจตัวไหนพิมพ์ *\"เอาเบอร์ 1 จำนวน 1 ชิ้น\"* หรือกดปุ่มใส่ตะกร้าได้เลยครับ!"
            )
            return {
                "reply": reply,
                "engine": "smart-fastpath",
                "stage_mode": "compare",
                "parsed_hints": [f"เปรียบเทียบ {len(picks)} รายการ"],
                "products": picks,
                "compare_products": picks,
                "coupons": _matching_coupons(coupons, picks),
                "cart": None,
                "actions": [],
                "suggestions": ["เอาเบอร์ 1 ใส่ตะกร้า", "เอาเบอร์ 2 ใส่ตะกร้า", "มีคูปองลดเพิ่มไหม"],
                "brain_path": _build_brain_path(msg, picks),
            }

    # 7. Pointed Product Detail Inspection ("ดูเบอร์ 1", "รายละเอียดตัวที่ 2")
    if card_indices and focus_products and re.search(r"(?:ดู|รายละเอียด|สเปก|ข้อมูล|เจาะลึก|ตัวที่|เบอร์|detail|info)", msg, re.I):
        idx = card_indices[0] - 1
        if 0 <= idx < len(focus_products):
            p = focus_products[idx]
            rel_cpns = _matching_coupons(coupons, [p])
            tag_str = " · ".join(TAG_META.get(t, {}).get("label", t) for t in (p.get("tags") or []))
            pack_str = f" (เฉลี่ย {fmt_baht(p.get('unit_price'))}/หน่วย)" if int(p.get("pack_qty") or 1) > 1 else ""
            reply = (
                f"**{p['name']}**\n"
                f"- ราคา **{fmt_baht(p['price'])}** / {p.get('unit') or 'ชิ้น'}{pack_str} · คงเหลือ **{p.get('stock_qty', 0)}**\n"
                f"- แบรนด์: {p.get('brand') or '-'} · ร้าน: **{p.get('shop')}**\n"
                + (f"- จุดเด่น: {tag_str}\n" if tag_str else "")
                + (f"- รายละเอียด: {p['description']}\n" if p.get("description") else "")
                + "สนใจรับกี่ชิ้นพิมพ์ *\"เอา 1 ชิ้น\"* หรือกดใส่ตะกร้าได้เลยครับ!"
            )
            return {
                "reply": reply,
                "engine": "smart-fastpath",
                "stage_mode": "detail",
                "parsed_hints": [f"ดูรายการ #{idx + 1}"],
                "products": [p],
                "compare_products": [],
                "coupons": rel_cpns,
                "cart": None,
                "actions": [],
                "suggestions": ["เอาตัวนี้ 1 ชิ้น", "เอาตัวนี้ 2 ชิ้น", "เปรียบเทียบกับรุ่นอื่น"],
                "brain_path": _build_brain_path(p["name"], [p]),
            }

    # 8. Smart Product Search + Hybrid LLM Sales Consultation
    hits, parsed = search_snapshot_products(
        products,
        msg,
        tags=active_dietary or None,
        limit=12,
    )
    rel_coupons = _matching_coupons(coupons, hits)
    hints = list(parsed.parsed_hints)
    for dt in active_dietary:
        lbl = f"{TAG_META[dt]['icon']} {TAG_META[dt]['label']}"
        if lbl not in hints:
            hints.append(lbl)

    if not hits:
        # Relax dietary/price constraints slightly to show helpful alternatives
        relaxed, _ = search_snapshot_products(products, parsed.clean_query or msg, limit=4)
        if relaxed:
            reply = (
                f"ยังไม่พบสินค้าที่ตรงเงื่อนไขทั้งหมดเป๊ะๆ สำหรับ *\"{msg}\"* ครับ "
                f"แต่น้องเอฟดีเจอสินค้าใกล้เคียง **{len(relaxed)} รายการ** ด้านขวา ลองดูเป็นตัวเลือกหรือปรับงบประมาณได้นะครับ!"
            )
            return {
                "reply": reply,
                "engine": "smart-fastpath",
                "stage_mode": "gallery",
                "parsed_hints": hints,
                "products": relaxed,
                "compare_products": [],
                "coupons": _matching_coupons(coupons, relaxed),
                "cart": None,
                "actions": [],
                "suggestions": ["ดูหมวดหมู่ทั้งหมด", "สินค้าขายดี", "มีคูปองส่วนลดไหม"],
                "brain_path": _build_brain_path(msg, relaxed),
            }
        reply = (
            f"ขออภัยครับ น้องเอฟดียังไม่พบสินค้าที่ตรงกับ *\"{msg}\"* ในคลังตอนนี้ครับ\n"
            f"ลองพิมพ์ชื่อหมวดหมู่หรือคำสั้นๆ เช่น *\"กาแฟ\"*, *\"สว่าน\"*, *\"น้ำปลา\"*, *\"อาหารแมว\"* หรือ *\"ดูหมวดหมู่ทั้งหมด\"* ได้เลยครับ!"
        )
        return {
            "reply": reply,
            "engine": "smart-fastpath",
            "stage_mode": "gallery",
            "parsed_hints": hints,
            "products": [],
            "compare_products": [],
            "coupons": coupons[:4],
            "cart": None,
            "actions": [],
            "suggestions": ["ดูหมวดหมู่ทั้งหมด", "อาหารฮาลาล ไม่เกิน 200", "หูฟังไร้สาย", "เครื่องมือช่าง"],
            "brain_path": None,
        }

    # Build deterministic grounded Thai sales response
    stage_mode = "detail" if len(hits) == 1 else "gallery"
    top_lines = []
    for idx, p in enumerate(hits[:5], start=1):
        unit_note = f" (เฉลี่ย {fmt_baht(p.get('unit_price'))}/หน่วย)" if int(p.get("pack_qty") or 1) > 1 else ""
        stock_note = "พร้อมส่ง" if int(p.get("stock_qty") or 0) > 0 else "หมดชั่วคราว"
        top_lines.append(f"**#{idx}** {p['name']} — **{fmt_baht(p['price'])}**/{p.get('unit') or 'ชิ้น'}{unit_note} · {stock_note}")
    cpn_note = f"\n🎟️ โปรแนะนำ: {_format_coupon_line(rel_coupons[0])}" if rel_coupons else ""
    fallback_reply = (
        f"น้องเอฟดีคัดมาให้ **{len(hits)} รายการ** ตรงโจทย์ครับ:\n"
        + "\n".join(top_lines)
        + cpn_note
        + "\n\nอยากให้เทียบสเปกพิมพ์ *\"เปรียบเทียบ 1 กับ 2\"* หรือสั่ง *\"เอาเบอร์ 1 จำนวน 1 ชิ้น\"* ได้เลยครับ!"
    )

    # Optional Hybrid LLM synthesis (only if API key configured)
    engine = "smart-fastpath"
    final_reply = fallback_reply
    llm_cfg = detect_llm_config()
    if llm_cfg is not None:
        polished = _call_llm_polish(llm_cfg, msg, history, hits, rel_coupons, fallback_reply)
        if polished:
            final_reply = polished
            engine = f"llm:{llm_cfg['model']}"

    next_suggestions = ["เอาเบอร์ 1 ใส่ตะกร้า"]
    if len(hits) >= 2:
        next_suggestions.append("เปรียบเทียบเบอร์ 1 กับ 2")
    next_suggestions.append("เรียงราคาถูกสุด" if parsed.inferred_sort != "price_asc" else "เรียงคุ้มสุดต่อหน่วย")
    if rel_coupons:
        next_suggestions.append("มีคูปองลดเพิ่มไหม")

    return {
        "reply": final_reply,
        "engine": engine,
        "stage_mode": stage_mode,
        "parsed_hints": hints,
        "products": hits,
        "compare_products": [],
        "coupons": rel_coupons,
        "cart": None,
        "actions": actions,
        "suggestions": next_suggestions[:4],
        "brain_path": _build_brain_path(parsed.clean_query or msg, hits),
    }
