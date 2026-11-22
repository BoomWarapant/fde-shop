"""MarketBrain-inspired Smart Query Parser, Bilingual Thai<->English Synonym Expander, and Hybrid Product Scorer.

Pure Python (standard library + Decimal only) so it runs fast on both local FastAPI and Vercel serverless.
"""
from __future__ import annotations

import re
from dataclasses import dataclass, field
from decimal import Decimal, InvalidOperation, ROUND_HALF_UP
from typing import Any

# ------------------------------------------------------------------ Trait / Dietary labels & triggers
TAG_META: dict[str, dict[str, str]] = {
    "halal": {"label": "ฮาลาล", "icon": "☪️"},
    "no_msg": {"label": "ไร้ผงชูรส", "icon": "🌿"},
    "low_sugar": {"label": "น้ำตาลน้อย/0%", "icon": "🍬"},
    "vegan": {"label": "เจ/วีแกน", "icon": "🥬"},
    "organic": {"label": "ออร์แกนิก", "icon": "🌱"},
    "fda": {"label": "มี อ.ย.", "icon": "🛡️"},
    "tis": {"label": "มาตรฐาน มอก.", "icon": "🏛️"},
    "warranty_1y": {"label": "ประกัน 1 ปี", "icon": "✅"},
    "bestseller": {"label": "ขายดี", "icon": "🔥"},
    "wholesale": {"label": "แพ็กคุ้ม/ขายส่ง", "icon": "📦"},
    "eco": {"label": "รักษ์โลก", "icon": "♻️"},
    "pet_safe": {"label": "ปลอดภัยต่อสัตว์เลี้ยง", "icon": "🐾"},
}

TRAIT_QUERY_RULES: list[tuple[re.Pattern[str], str, str]] = [
    (re.compile(r"(?:ฮาลาล|halal)", re.I), "halal", "ฮาลาล"),
    (re.compile(r"(?:ไม่ใส่ผงชูรส|ไม่มีผงชูรส|ไร้ผงชูรส|ปลอดผงชูรส|no\s*msg)", re.I), "no_msg", "ไร้ผงชูรส"),
    (re.compile(r"(?:น้ำตาลน้อย|ไม่มีน้ำตาล|ไม่เติมน้ำตาล|ไม่หวาน|ไร้น้ำตาล|0\s*%|low\s*sugar|sugar\s*free|zero\s*sugar)", re.I), "low_sugar", "น้ำตาลน้อย/0%"),
    (re.compile(r"(?:วีแกน|มังสวิรัติ|อาหารเจ|ทานเจ|\bvegan\b)", re.I), "vegan", "เจ/วีแกน"),
    (re.compile(r"(?:ออร์แกนิก|ออร์แกนิค|อินทรีย์|\borganic\b)", re.I), "organic", "ออร์แกนิก"),
    (re.compile(r"(?:มอก\.?|\btis\b)", re.I), "tis", "มอก."),
    (re.compile(r"(?:อ\.?ย\.?|\bfda\b)", re.I), "fda", "มี อ.ย."),
    (re.compile(r"(?:ยกลัง|ราคาส่ง|ขายส่ง|แพ็กคุ้ม|แพ็คคุ้ม|\bwholesale\b)", re.I), "wholesale", "แพ็กคุ้ม/ขายส่ง"),
    (re.compile(r"(?:ประกัน\s*1\s*ปี|มีประกัน|\bwarranty\b)", re.I), "warranty_1y", "ประกัน 1 ปี"),
    (re.compile(r"(?:รักษ์โลก|\beco\b)", re.I), "eco", "รักษ์โลก"),
]

# ------------------------------------------------------------------ Bidirectional Thai <-> English Equivalence Groups
BILINGUAL_EQUIV_GROUPS: tuple[tuple[str, ...], ...] = (
    # Tools & Hardware Brands
    ("มากิต้า", "มากีต้า", "มาคิต้า", "makita"),
    ("บ๊อช", "บอช", "bosch"),
    ("ดีวอลท์", "เดวอลท์", "ดิวอลท์", "dewalt"),
    ("สแตนเลย์", "สแตนลีย์", "stanley"),
    ("พัมคิน", "ปั๊มกิ้น", "พัมกิ้น", "pumpkin"),
    ("เฮเฟเล่", "ฮาเฟเล่", "hafele"),
    ("คอตโต้", "cotto"),
    ("เอสซีจี", "scg"),
    ("โซโล", "solo"),
    # Tech & Home Brands
    ("แองเกอร์", "anker"),
    ("ยูกรีน", "ugreen"),
    ("โซนี่", "sony"),
    ("โลจิเทค", "logitech"),
    ("เสียวหมี่", "xiaomi"),
    ("ฟิลิปส์", "philips"),
    ("ทีฟาล์ว", "tefal"),
    ("ชาร์ป", "sharp"),
    ("แซนดิสก์", "sandisk"),
    ("คีย์ครอน", "keychron"),
    ("เจบีแอล", "jbl"),
    # FMCG / Pet / Baby / Beauty Brands
    ("ปลาหมึก", "squid"),
    ("ทิพรส", "tiparos"),
    ("เมกะเชฟ", "megachef"),
    ("อร่อยดี", "aroy-d"),
    ("ดอยคำ", "doikham"),
    ("ดอยช้าง", "doi chaang"),
    ("มาม่า", "mama"),
    ("ซีเล็ค", "sealect"),
    ("ไฮคิว", "hi-q", "hiq"),
    ("มามี่โพโค", "mamypoko"),
    ("รอยัลคานิน", "royal canin"),
    ("มีโอ", "me-o", "meo"),
    ("สมาร์ทฮาร์ท", "smartheart"),
    ("เชา", "ciao"),
    ("เซราวี", "cerave"),
    ("อเนสซ่า", "anessa"),
    ("มิซึมิ", "mizumi"),
    ("ไบโอเดอร์มา", "bioderma"),
    ("แบลคมอร์ส", "blackmores"),
    # Product Nouns (Thai <-> English)
    ("สว่าน", "drill", "สว่านไร้สาย", "สว่านไฟฟ้า"),
    ("หินเจียร", "ลูกหมู", "เครื่องเจียร", "grinder"),
    ("ไขควง", "screwdriver"),
    ("ตลับเมตร", "measuring tape", "tape measure"),
    ("คีม", "pliers"),
    ("ประแจ", "wrench"),
    ("คัตเตอร์", "cutter"),
    ("บันได", "ladder"),
    ("เครื่องฉีดน้ำ", "pressure washer"),
    ("น้ำปลา", "fish sauce"),
    ("ซีอิ๊ว", "ซอสถั่วเหลือง", "soy sauce"),
    ("ซอสหอยนางรม", "น้ำมันหอย", "oyster sauce"),
    ("น้ำมัน", "oil", "cooking oil"),
    ("ข้าวหอมมะลิ", "ข้าวสาร", "jasmine rice", "rice"),
    ("บะหมี่", "มาม่า", "noodle", "instant noodle"),
    ("กะทิ", "coconut milk"),
    ("ทูน่า", "ปลาทูน่า", "tuna"),
    ("กาแฟ", "coffee", "espresso", "drip coffee"),
    ("ชาเขียว", "มัทฉะ", "matcha", "green tea"),
    ("ชา", "tea"),
    ("นม", "milk", "นมกล่อง", "นมผง"),
    ("น้ำแร่", "น้ำดื่ม", "water", "mineral water"),
    ("ขนม", "snack", "snacks"),
    ("อัลมอนด์", "almond"),
    ("ช็อกโกแลต", "chocolate"),
    ("กระทะ", "pan", "frying pan"),
    ("หม้อหุงข้าว", "rice cooker"),
    ("หม้อทอด", "air fryer", "หม้อทอดไร้น้ำมัน"),
    ("กาต้มน้ำ", "kettle", "electric kettle"),
    ("แก้วกาแฟ", "mug", "coffee mug"),
    ("ขวดน้ำ", "แก้วเก็บความเย็น", "water bottle", "tumbler", "bottle"),
    ("เขียง", "cutting board"),
    ("ปลอกหมอน", "หมอน", "cushion", "pillow"),
    ("ผ้าปูที่นอน", "bedding", "bedsheet"),
    ("เทียนหอม", "candle", "soy candle"),
    ("น้ำยาล้างจาน", "dishwashing"),
    ("ผงซักฟอก", "detergent", "laundry"),
    ("ทิชชู่", "กระดาษชำระ", "tissue"),
    ("หัวชาร์จ", "สายชาร์จ", "ที่ชาร์จ", "charger", "usb-c"),
    ("พาวเวอร์แบงค์", "แบตสำรอง", "power bank", "powerbank"),
    ("ปลั๊กไฟ", "ปลั๊กพ่วง", "power strip", "smart plug"),
    ("หูฟัง", "earbuds", "headphone", "headphones", "earphone"),
    ("ลำโพง", "speaker"),
    ("นาฬิกา", "smartwatch", "watch"),
    ("คีย์บอร์ด", "keyboard"),
    ("เมาส์", "mouse"),
    ("กล้องวงจรปิด", "cctv", "camera", "webcam"),
    ("กระเป๋า", "bag", "tote", "backpack", "sleeve"),
    ("เสื้อยืด", "เสื้อ", "shirt", "t-shirt", "polo"),
    ("รองเท้า", "shoes", "sneakers", "sandals"),
    ("เสื่อโยคะ", "yoga mat"),
    ("ดัมเบล", "dumbbell"),
    ("เต็นท์", "แคมป์ปิ้ง", "tent", "camping"),
    ("อาหารแมว", "cat food", "แมว"),
    ("ทรายแมว", "cat litter"),
    ("อาหารสุนัข", "อาหารหมา", "dog food", "สุนัข", "หมา"),
    ("สัตว์เลี้ยง", "pet", "pets"),
    ("กันแดด", "ครีมกันแดด", "sunscreen", "uv"),
    ("ล้างหน้า", "cleanser", "คลีนซิ่ง"),
    ("เซรั่ม", "serum"),
    ("แชมพู", "shampoo"),
    ("ยาสีฟัน", "toothpaste"),
    ("วิตามิน", "vitamin", "vitamins", "supplement"),
    ("หน้ากาก", "หน้ากากอนามัย", "mask"),
    ("ผ้าอ้อม", "diaper", "diapers"),
    ("ขวดนม", "baby bottle"),
    ("ปากกา", "pen", "highlighter"),
    ("สมุด", "notebook"),
    ("กระดาษ", "paper", "a4"),
    ("โซลาร์เซลล์", "solar", "โคมไฟ"),
    ("สายยาง", "hose", "รดน้ำ"),
    ("ล้างรถ", "car wash", "รถยนต์"),
)

# Pre-compute fast lookup map: lower term -> set of equivalent lower terms
_SYNONYM_MAP: dict[str, set[str]] = {}
for _grp in BILINGUAL_EQUIV_GROUPS:
    _lows = [g.lower() for g in _grp]
    for _t in _lows:
        _SYNONYM_MAP.setdefault(_t, set()).update(_lows)

# ------------------------------------------------------------------ Smart Query Parser
_EXCLUDE_CLAIM_PREFIX_RE = re.compile(r"^ไม่(?:ใส่|มี|เติม|เจือ)")
_BARCODE_GROUPED_RE = re.compile(r"(?<![\d.])\d{3,4}(?:[- ]\d{3,5}){1,3}(?![\d.])")
_BARCODE_PLAIN_RE = re.compile(r"(?<![\d-])\d{8,14}(?![\d-])")
_MINUS_TERM_RE = re.compile(r'(?<=\s)-(?:"([^"]+)"|\'([^\']+)\'|([^\s,;|]+))')
_THAI_EXCLUDE_RE = re.compile(r"(?:ไม่ต้องเอา|ไม่เอา|ยกเว้น|ห้ามมี)\s*([^\s,;|]+)")
_PRICE_RANGE_BAHT_RE = re.compile(
    r"(?:(?:ราคา|งบ|ตั้งแต่)\s*)?(\d{1,6}(?:,\d{3})*(?:\.\d{1,2})?)\s*(?:-|ถึง|–|~)\s*(\d{1,6}(?:,\d{3})*(?:\.\d{1,2})?)\s*(?:บาท|บ\.?)"
)
_PRICE_RANGE_PLAIN_RE = re.compile(
    r"(?:ราคา|งบ|ตั้งแต่)\s*(\d{1,6}(?:,\d{3})*(?:\.\d{1,2})?)\s*(?:-|ถึง|–|~)\s*(\d{1,6}(?:,\d{3})*(?:\.\d{1,2})?)(?=\s|$)"
)
_MAX_PRICE_RE = re.compile(
    r"(?:(?:ราคา|งบ(?:ประมาณ)?)\s*)?(?:ไม่เกิน|ต่ำกว่า|น้อยกว่า|<=|<|under|below|max)\s*(\d{1,6}(?:,\d{3})*(?:\.\d{1,2})?)\s*(?:บาท|บ\.?|thb)?",
    re.I,
)
_BUDGET_RE = re.compile(
    r"(?:งบ(?:ประมาณ)?|budget)\s*(\d{1,6}(?:,\d{3})*(?:\.\d{1,2})?)\s*(?:บาท|บ\.?|thb)?",
    re.I,
)
_MIN_PRICE_RE = re.compile(
    r"(?:ราคา\s*)?(?:ตั้งแต่|มากกว่า|เกิน|>=|>|over|above|min)\s*(\d{1,6}(?:,\d{3})*(?:\.\d{1,2})?)\s*(?:บาท|บ\.?|thb)?",
    re.I,
)

_SORT_RULES: list[tuple[re.Pattern[str], str, str]] = [
    (re.compile(r"(?:ราคาถูกสุด|ราคาต่ำสุด|ถูกที่สุด|ถูกสุด|cheapest|lowest\s*price)", re.I), "price_asc", "เรียง: ราคาต่ำ → สูง"),
    (re.compile(r"(?:ราคาแพงสุด|ราคาสูงสุด|แพงที่สุด|แพงสุด|most\s*expensive)", re.I), "price_desc", "เรียง: ราคาสูง → ต่ำ"),
    (re.compile(r"(?:เฉลี่ยถูกสุด|คุ้มที่สุด|คุ้มสุด|ต่อชิ้นถูกสุด|best\s*value)", re.I), "unit_price_asc", "เรียง: ราคาต่อหน่วยคุ้มสุด"),
    (re.compile(r"(?:ขายดีสุด|ขายดีที่สุด|ยอดนิยม|popular|best\s*sell(?:er|ing))", re.I), "popular", "เรียง: ขายดี"),
]

_STOPWORDS = {
    "หา", "ค้นหา", "อยากได้", "ต้องการ", "ขอ", "แนะนำ", "หน่อย", "ครับ", "ค่ะ", "นะ", "นะครับ", "นะคะ",
    "มี", "ไหม", "มั้ย", "บ้าง", "ที่", "ของ", "ให้", "ด้วย", "สัก", "ช่วย", "ดู", "สินค้า", "รายการ",
    "find", "search", "show", "me", "want", "need", "please", "recommend", "some", "any", "for", "with", "the", "a", "an",
}


def normalize_measurements(text: str) -> str:
    """Normalize joined metric units (e.g. '500ml' -> '500 มล', '1.5kg' -> '1.5 กก')."""
    s = re.sub(r"(\d+(?:\.\d+)?)\s*(?:ม\.ล\.|มล\.?|ml)\b", r"\1 มล", text, flags=re.I)
    s = re.sub(r"(\d+(?:\.\d+)?)\s*(?:ลิตร|ล\.?)(?![a-zก-๙\d])", r"\1 ล", s, flags=re.I)
    s = re.sub(r"(\d+(?:\.\d+)?)\s*(?:ก\.ก\.|กก\.?|kg)\b", r"\1 กก", s, flags=re.I)
    s = re.sub(r"(\d+(?:\.\d+)?)\s*(?:กรัม)(?![a-zก-๙\d])", r"\1 ก", s, flags=re.I)
    s = re.sub(r"(\d+(?:\.\d+)?)\s*(?:วัตต์|watts?)(?![a-zก-๙\d/])", r"\1 วัตต์", s, flags=re.I)
    return s


def _to_decimal(val: str) -> Decimal | None:
    try:
        d = Decimal(val.replace(",", "").strip())
        return d.quantize(Decimal("0.01"), rounding=ROUND_HALF_UP) if d >= 0 else None
    except InvalidOperation:
        return None


@dataclass
class ParsedSmartQuery:
    raw_query: str
    clean_query: str
    barcodes: list[str] = field(default_factory=list)
    min_price: Decimal | None = None
    max_price: Decimal | None = None
    exclude_terms: list[str] = field(default_factory=list)
    inferred_tags: list[str] = field(default_factory=list)
    inferred_sort: str | None = None
    parsed_hints: list[str] = field(default_factory=list)
    expanded_terms: list[str] = field(default_factory=list)


def expand_bilingual_terms(query: str) -> list[str]:
    """Return unique lowercase tokens + bilingual Thai<->English synonym expansions."""
    q = normalize_measurements(query).lower().strip()
    if not q:
        return []
    found: list[str] = []
    seen: set[str] = set()

    def _add(t: str) -> None:
        t = t.strip().lower()
        if t and len(t) >= 2 and t not in seen:
            seen.add(t)
            found.append(t)

    # Whole phrase & whitespace tokens
    raw_tokens = [tok for tok in re.split(r"[\s,;/|]+", q) if tok and tok not in _STOPWORDS]
    for tok in raw_tokens:
        _add(tok)

    # Check multi-word and substring matches against synonym dictionary (Thai has no word spaces!)
    for key, equivs in _SYNONYM_MAP.items():
        if key in q:
            for eq in equivs:
                _add(eq)

    return found


def parse_smart_query(raw: str) -> ParsedSmartQuery:
    """Parse natural Thai/English search operators cleanly (inspired by MarketBrain lib/smart-search.ts)."""
    raw_q = (raw or "").strip()
    if not raw_q:
        return ParsedSmartQuery(raw_query="", clean_query="")

    work = f" {raw_q} "
    barcodes: list[str] = []
    excludes: list[str] = []
    inferred_tags: list[str] = []
    hints: list[str] = []
    min_price: Decimal | None = None
    max_price: Decimal | None = None
    inferred_sort: str | None = None

    # 1. Barcodes (8-14 digits)
    def _cap_grouped_bc(m: re.Match[str]) -> str:
        compact = re.sub(r"[\s-]+", "", m.group(0))
        if 8 <= len(compact) <= 14:
            if compact not in barcodes:
                barcodes.append(compact)
                hints.append(f"บาร์โค้ด {compact}")
            return " "
        return m.group(0)

    work = _BARCODE_GROUPED_RE.sub(_cap_grouped_bc, work)

    def _cap_plain_bc(m: re.Match[str]) -> str:
        bc = m.group(0)
        if bc not in barcodes:
            barcodes.append(bc)
            hints.append(f"บาร์โค้ด {bc}")
        return " "

    work = _BARCODE_PLAIN_RE.sub(_cap_plain_bc, work)

    # 2. Negative exclusions (-term or "ไม่เอา xxx"), guarding product claims like "ไม่ใส่ผงชูรส"
    def _cap_minus(m: re.Match[str]) -> str:
        val = (m.group(1) or m.group(2) or m.group(3) or "").strip()
        if not val or re.fullmatch(r"\d+(?:[.,/-]\d+)*", val):
            return m.group(0)
        if val not in excludes:
            excludes.append(val)
            hints.append(f"ตัดคำ: -{val}")
        return " "

    work = _MINUS_TERM_RE.sub(_cap_minus, work)

    def _cap_thai_excl(m: re.Match[str]) -> str:
        if _EXCLUDE_CLAIM_PREFIX_RE.match(m.group(0)):
            return m.group(0)
        val = re.sub(r"^(?:คำว่า|สินค้า|ตรา|ยี่ห้อ|แบรนด์)", "", m.group(1)).strip()
        if not val:
            return m.group(0)
        if val not in excludes:
            excludes.append(val)
            hints.append(f"ตัดคำ: -{val}")
        return " "

    work = _THAI_EXCLUDE_RE.sub(_cap_thai_excl, work)

    # 3. Natural sort intent
    for pattern, sort_val, label in _SORT_RULES:
        if pattern.search(work):
            work = pattern.sub(" ", work)
            if not inferred_sort:
                inferred_sort = sort_val
                hints.append(label)

    # 4. Price range / budget bounds (strictly Decimal)
    def _cap_range(m: re.Match[str]) -> str:
        nonlocal min_price, max_price
        lo, hi = _to_decimal(m.group(1)), _to_decimal(m.group(2))
        if lo is not None and hi is not None:
            if lo > hi:
                lo, hi = hi, lo
            min_price, max_price = lo, hi
            hints.append(f"ราคา ฿{lo:,.0f}–฿{hi:,.0f}")
            return " "
        return m.group(0)

    work = _PRICE_RANGE_BAHT_RE.sub(_cap_range, work)
    if min_price is None and max_price is None:
        work = _PRICE_RANGE_PLAIN_RE.sub(_cap_range, work)

    def _cap_max(m: re.Match[str]) -> str:
        nonlocal max_price
        hi = _to_decimal(m.group(1))
        if hi is not None:
            max_price = hi
            hints.append(f"ไม่เกิน ฿{hi:,.0f}")
            return " "
        return m.group(0)

    work = _MAX_PRICE_RE.sub(_cap_max, work)
    if max_price is None:
        work = _BUDGET_RE.sub(_cap_max, work)

    def _cap_min(m: re.Match[str]) -> str:
        nonlocal min_price
        lo = _to_decimal(m.group(1))
        if lo is not None:
            min_price = lo
            hints.append(f"ตั้งแต่ ฿{lo:,.0f}")
            return " "
        return m.group(0)

    work = _MIN_PRICE_RE.sub(_cap_min, work)

    # 5. Trait / dietary intents (strip recognized trait tokens so clean_query focuses on product nouns)
    for pattern, tag_id, label in TRAIT_QUERY_RULES:
        if pattern.search(work):
            work = pattern.sub(" ", work)
            if tag_id not in inferred_tags:
                inferred_tags.append(tag_id)
                hints.append(f"{TAG_META[tag_id]['icon']} {label}")

    clean_query = re.sub(r"\s+", " ", work).strip()
    # Strip leading/trailing filler words for better product matching
    tokens = [t for t in clean_query.split(" ") if t and t.lower() not in _STOPWORDS]
    clean_query = " ".join(tokens).strip()
    expanded = expand_bilingual_terms(clean_query)

    return ParsedSmartQuery(
        raw_query=raw_q,
        clean_query=clean_query,
        barcodes=barcodes,
        min_price=min_price,
        max_price=max_price,
        exclude_terms=excludes,
        inferred_tags=inferred_tags,
        inferred_sort=inferred_sort,
        parsed_hints=hints,
        expanded_terms=expanded,
    )


# ------------------------------------------------------------------ Hybrid Scorer (In-RAM for Bot & Suggest)
def _product_haystack(p: dict[str, Any]) -> str:
    tags = p.get("tags") or []
    tag_labels = " ".join(TAG_META.get(t, {}).get("label", t) for t in tags)
    return " ".join(
        str(x)
        for x in (
            p.get("name") or "",
            p.get("brand") or "",
            p.get("category") or "",
            p.get("category_th") or "",
            p.get("parent_category") or "",
            p.get("parent_category_th") or "",
            p.get("shop") or "",
            p.get("description") or "",
            p.get("sku") or "",
            p.get("barcode") or "",
            p.get("unit") or "",
            " ".join(tags),
            tag_labels,
        )
    ).lower()


def _decimal_price(val: Any) -> Decimal:
    try:
        return Decimal(str(val or 0))
    except InvalidOperation:
        return Decimal(0)


def search_snapshot_products(
    products: list[dict[str, Any]],
    query: str = "",
    *,
    category_id: int | None = None,
    brand: str | None = None,
    min_price: Decimal | None = None,
    max_price: Decimal | None = None,
    tags: list[str] | None = None,
    in_stock: bool = False,
    sort: str | None = None,
    limit: int = 12,
) -> tuple[list[dict[str, Any]], ParsedSmartQuery]:
    """Run MarketBrain-style hybrid search over the catalog snapshot with smart query parsing & bilingual ranking."""
    parsed = parse_smart_query(query)
    eff_min = min_price if min_price is not None else parsed.min_price
    eff_max = max_price if max_price is not None else parsed.max_price
    eff_tags = list(dict.fromkeys([*(tags or []), *parsed.inferred_tags]))
    eff_sort = sort or parsed.inferred_sort or "relevance"
    eff_excludes = [e.lower() for e in parsed.exclude_terms]
    clean_low = normalize_measurements(parsed.clean_query).lower()

    # Build synonym groups for each user concept so multi-word bilingual phrases ("fish sauce", "cat food")
    # and compound Thai phrases ("สว่านมากิต้า") expand cleanly!
    token_groups: list[set[str]] = []
    remaining = clean_low

    # 1) Match multi-word synonym keys first (longest first) e.g. "fish sauce", "cat food", "water bottle"
    multi_keys = sorted((k for k in _SYNONYM_MAP if " " in k), key=len, reverse=True)
    for mk in multi_keys:
        if mk in remaining:
            token_groups.append(set(_SYNONYM_MAP[mk]))
            remaining = remaining.replace(mk, " ")

    # 2) Tokenize remaining text
    raw_toks = [t for t in re.split(r"[\s,;/|]+", remaining) if t and len(t) >= 2 and t not in _STOPWORDS]
    for tok in raw_toks:
        # Handle spaceless Thai compound words (e.g. "สว่านมากิต้า" -> ["สว่าน", "มากิต้า"])
        sub_keys = sorted((k for k in _SYNONYM_MAP if " " not in k and len(k) >= 2 and k in tok and k != tok), key=len, reverse=True)
        if len(sub_keys) >= 2:
            used_sets: list[frozenset[str]] = []
            for sk in sub_keys:
                fs = frozenset(_SYNONYM_MAP[sk])
                if fs not in used_sets:
                    used_sets.append(fs)
                    token_groups.append(set(fs))
        else:
            grp = {tok}
            if tok in _SYNONYM_MAP:
                grp.update(_SYNONYM_MAP[tok])
            else:
                for key, equivs in _SYNONYM_MAP.items():
                    if " " not in key and len(key) >= 3 and key in tok:
                        grp.update(equivs)
            token_groups.append(grp)

    scored: list[tuple[float, dict[str, Any]]] = []
    for p in products:
        if category_id is not None:
            if p.get("category_id") != category_id and p.get("parent_category_id") != category_id:
                continue
        if brand and (p.get("brand") or "").lower() != brand.lower():
            continue
        price = _decimal_price(p.get("price"))
        if eff_min is not None and price < eff_min:
            continue
        if eff_max is not None and price > eff_max:
            continue
        if in_stock and int(p.get("stock_qty") or 0) <= 0:
            continue
        p_tags = set(p.get("tags") or [])
        if eff_tags and not set(eff_tags).issubset(p_tags):
            continue

        hay = _product_haystack(p)
        if eff_excludes and any(ex in hay for ex in eff_excludes):
            continue

        score = 0.0
        name_low = (p.get("name") or "").lower()
        brand_low = (p.get("brand") or "").lower()
        cat_low = f"{p.get('category') or ''} {p.get('category_th') or ''} {p.get('parent_category') or ''} {p.get('parent_category_th') or ''}".lower()
        bc = (p.get("barcode") or "").strip()
        sku = (p.get("sku") or "").lower()

        if parsed.barcodes:
            if bc in parsed.barcodes or any(b in hay for b in parsed.barcodes):
                score += 200.0
            else:
                continue

        if token_groups:
            group_hits = 0
            for grp in token_groups:
                hit_val = 0.0
                for term in grp:
                    if term == sku:
                        hit_val = max(hit_val, 120.0)
                    elif term in name_low:
                        hit_val = max(hit_val, 35.0)
                    elif term in brand_low:
                        hit_val = max(hit_val, 30.0)
                    elif term in cat_low:
                        hit_val = max(hit_val, 22.0)
                    elif term in hay:
                        hit_val = max(hit_val, 12.0)
                if hit_val > 0:
                    group_hits += 1
                    score += hit_val
            if group_hits == 0:
                continue
            # Strongly reward matching ALL query concepts (e.g. "สว่าน" AND "มากิต้า")
            if group_hits == len(token_groups):
                score += 40.0 * group_hits
            if clean_low and clean_low in name_low:
                score += 45.0
        else:
            # Filter-only query (e.g. "ฮาลาล ไม่เกิน 200")
            score = 10.0

        if int(p.get("stock_qty") or 0) > 0:
            score += 5.0
        if "bestseller" in p_tags:
            score += 4.0
        score += min(float(p.get("sold") or 0) * 0.2, 8.0)

        scored.append((score, p))

    if eff_sort == "price_asc":
        scored.sort(key=lambda x: (_decimal_price(x[1].get("price")), -x[0]))
    elif eff_sort == "price_desc":
        scored.sort(key=lambda x: (-_decimal_price(x[1].get("price")), -x[0]))
    elif eff_sort == "unit_price_asc":
        scored.sort(key=lambda x: (_decimal_price(x[1].get("unit_price") or x[1].get("price")), -x[0]))
    elif eff_sort == "popular":
        scored.sort(key=lambda x: (-int(x[1].get("sold") or 0), -("bestseller" in (x[1].get("tags") or [])), -x[0]))
    else:
        scored.sort(key=lambda x: (-x[0], -int(x[1].get("sold") or 0), -int(x[1].get("product_id") or 0)))

    return [p for _, p in scored[:limit]], parsed


def build_suggestions(snapshot: dict[str, Any], q: str, limit: int = 8) -> dict[str, Any]:
    """Build fast autocomplete suggestions (products, categories, brands) for the search bar."""
    raw = (q or "").strip()
    products = snapshot.get("products") or []
    categories = snapshot.get("categories") or []
    if not raw:
        top_cats = [c for c in categories if not c.get("parent_id")][:8]
        return {"query": "", "products": [], "categories": top_cats, "brands": [], "parsed_hints": []}

    hits, parsed = search_snapshot_products(products, raw, limit=limit)
    q_low = raw.lower()
    expanded = set(parsed.expanded_terms or [q_low])

    cat_hits = []
    for c in categories:
        cname = f"{c.get('name') or ''} {c.get('name_th') or ''}".lower()
        if q_low in cname or any(t in cname for t in expanded):
            cat_hits.append(c)
        if len(cat_hits) >= 5:
            break

    brand_counts: dict[str, int] = {}
    for p in products:
        b = (p.get("brand") or "").strip()
        if not b:
            continue
        bl = b.lower()
        if q_low in bl or any(t in bl for t in expanded):
            brand_counts[b] = brand_counts.get(b, 0) + 1
    top_brands = [{"brand": b, "count": c} for b, c in sorted(brand_counts.items(), key=lambda x: (-x[1], x[0]))[:5]]

    return {
        "query": raw,
        "parsed_hints": parsed.parsed_hints,
        "products": [
            {
                "product_id": p["product_id"],
                "name": p["name"],
                "brand": p.get("brand"),
                "price": p["price"],
                "unit": p.get("unit"),
                "image_url": p.get("image_url"),
                "category_th": p.get("category_th") or p.get("category"),
                "shop": p.get("shop"),
            }
            for p in hits
        ],
        "categories": cat_hits,
        "brands": top_brands,
    }
