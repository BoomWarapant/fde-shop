"""Generate an idempotent SQL seed file (supabase/seed_catalog.sql) from scripts/catalog_data.py.

Can be applied directly with:
  supabase db query --remote=xsjiuymwxkbfcczgphss -f supabase/seed_catalog.sql --yes
"""
from __future__ import annotations

from pathlib import Path
from catalog_data import CATEGORY_TREE, build_product_records

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "supabase" / "seed_catalog.sql"


def sql_str(val: str | None) -> str:
    if val is None:
        return "null"
    return "'" + val.replace("'", "''") + "'"


def sql_text_arr(vals: list[str]) -> str:
    if not vals:
        return "'{}'::text[]"
    return "array[" + ", ".join(sql_str(v) for v in vals) + "]::text[]"


# Map each seller group to its preferred shop name, falling back cleanly to existing demo shops
SHOP_PREFERENCE = {
    "SHOP_SELLER_A": ("Somsri Home & Living", "Somsri Home & Living"),
    "SHOP_SELLER_B": ("Tech Corner BKK", "Tech Corner BKK"),
    "SHOP_SELLER_C": ("Pantry Siam Mart", "Somsri Home & Living"),
    "SHOP_SELLER_D": ("Chang Pro Hardware", "Tech Corner BKK"),
    "SHOP_SELLER_E": ("Urban Fit & Style", "Somsri Home & Living"),
    "SHOP_SELLER_F": ("Paw & Glow Studio", "Somsri Home & Living"),
}


def generate() -> str:
    lines: list[str] = [
        "-- Auto-generated idempotent catalog seed: 12 main categories, 36 subcategories, 263 products, shop coupons.",
        "-- Safe to re-run: preserves existing products' stock_qty while enriching metadata, writes INITIAL stock_movements for new items.",
        "begin;",
        "",
        "-- 1. Upsert 12 main categories",
    ]
    for name, name_th, slug, icon, sort_order, _children in CATEGORY_TREE:
        lines.append(
            f"insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) "
            f"values ({sql_str(name)}, {sql_str(name_th)}, {sql_str(slug)}, {sql_str(icon)}, {sort_order}, null) "
            f"on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, "
            f"icon = excluded.icon, sort_order = excluded.sort_order, parent_id = null;"
        )

    lines.append("")
    lines.append("-- 2. Upsert 36 subcategories linked to parent categories")
    for pname, _pname_th, _pslug, _picon, sort_order, children in CATEGORY_TREE:
        for idx, (cname, cname_th, cslug, cicon) in enumerate(children, start=1):
            lines.append(
                f"insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) "
                f"values ({sql_str(cname)}, {sql_str(cname_th)}, {sql_str(cslug)}, {sql_str(cicon)}, {sort_order * 10 + idx}, "
                f"(select category_id from public.categories where name = {sql_str(pname)})) "
                f"on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, "
                f"icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;"
            )

    lines.append("")
    lines.append("-- 3. Upsert 263 products (enrich existing, insert new + INITIAL stock_movements)")
    lines.append("do $$")
    lines.append("declare")
    lines.append("    v_shop_id bigint;")
    lines.append("    v_cat_id  integer;")
    lines.append("    v_pid     bigint;")
    lines.append("begin")

    for rec in build_product_records():
        pref_shop, fallback_shop = SHOP_PREFERENCE[rec["seller"]]
        lines.append(
            f"    select coalesce((select shop_id from public.shops where name = {sql_str(pref_shop)}), "
            f"(select shop_id from public.shops where name = {sql_str(fallback_shop)}), "
            f"(select min(shop_id) from public.shops)) into v_shop_id;"
        )
        lines.append(
            f"    select category_id into v_cat_id from public.categories where name = {sql_str(rec['category'])};"
        )
        lines.append(
            f"    select product_id into v_pid from public.products where name = {sql_str(rec['name'])} limit 1;"
        )
        lines.append("    if v_pid is null then")
        lines.append(
            f"        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, "
            f"low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) "
            f"values (v_shop_id, {sql_str(rec['name'])}, {sql_str(rec['description'])}, v_cat_id, {rec['price']}, "
            f"{sql_str(rec['image_url'])}, {rec['stock_qty']}, 5, true, {sql_str(rec['brand'])}, {sql_str(rec['sku'])}, "
            f"{sql_str(rec['barcode'])}, {sql_str(rec['unit'])}, {rec['pack_qty']}, {sql_text_arr(rec['tags'])}) "
            f"returning product_id into v_pid;"
        )
        if rec["stock_qty"] > 0:
            lines.append(
                f"        insert into public.stock_movements (product_id, qty_change, reason, note) "
                f"values (v_pid, {rec['stock_qty']}, 'INITIAL', 'Catalog seed');"
            )
        lines.append("    else")
        lines.append(
            f"        update public.products set description = {sql_str(rec['description'])}, category_id = coalesce(v_cat_id, category_id), "
            f"image_url = coalesce(image_url, {sql_str(rec['image_url'])}), brand = {sql_str(rec['brand'])}, "
            f"sku = {sql_str(rec['sku'])}, barcode = {sql_str(rec['barcode'])}, unit = {sql_str(rec['unit'])}, "
            f"pack_qty = {rec['pack_qty']}, tags = {sql_text_arr(rec['tags'])} where product_id = v_pid;"
        )
        lines.append("    end if;")

    lines.append("end $$;")
    lines.append("")
    lines.append("-- 4. Add shop coupons if missing")
    coupons_sql = [
        ("TECH100", "Tech Corner BKK", "FIXED", 100, "null", 1000, 200, 2),
        ("PANTRY15", "Somsri Home & Living", "PERCENT", 15, "120", 400, 300, 3),
        ("CHANG150", "Tech Corner BKK", "FIXED", 150, "null", 1500, 150, 2),
    ]
    for code, shop_name, dtype, dval, max_d, min_amt, lim_tot, lim_usr in coupons_sql:
        lines.append(
            f"insert into public.coupons (code, shop_id, discount_type, discount_value, max_discount, min_order_amount, "
            f"usage_limit_total, usage_limit_per_user, starts_at, expires_at) "
            f"select {sql_str(code)}, s.shop_id, {sql_str(dtype)}, {dval}, {max_d}, {min_amt}, {lim_tot}, {lim_usr}, "
            f"now(), now() + interval '90 days' from public.shops s where s.name = {sql_str(shop_name)} "
            f"on conflict (code) do nothing;"
        )

    lines.append("")
    lines.append("commit;")
    return "\n".join(lines) + "\n"


if __name__ == "__main__":
    OUT.write_text(generate(), encoding="utf-8")
    print(f"Wrote {OUT} ({OUT.stat().st_size} bytes)")
