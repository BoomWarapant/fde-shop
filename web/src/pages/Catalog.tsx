import { useQueryClient } from "@tanstack/react-query";
import { Bot, Check, ImageOff, Megaphone, RotateCcw, ShoppingCart, Sparkles, Tag } from "lucide-react";
import { useState } from "react";
import { Link, useNavigate, useParams } from "react-router";
import { TAG_LABEL_MAP, TRAIT_CHIPS, useBot } from "../components/BotContext";
import { Card, cx, ErrorState, PageHeader, Select } from "../components/ui";
import { apiSend, errorText, useApi, useUrlState } from "../lib/api";
import { useAuth } from "../lib/auth";
import { baht, num } from "../lib/format";

export interface CatalogItem {
  product_id: number;
  name: string;
  description?: string | null;
  price: number;
  unit_price?: number;
  image_url: string | null;
  stock_qty: number;
  category_id?: number | null;
  parent_category_id?: number | null;
  category: string | null;
  category_th?: string | null;
  shop_id: number;
  shop: string;
  brand?: string | null;
  unit?: string | null;
  pack_qty?: number | null;
  tags?: string[];
  sold: number;
}

export interface CategoryNode {
  category_id: number;
  name: string;
  name_th?: string | null;
  parent_id?: number | null;
  slug?: string | null;
  icon?: string | null;
  sort_order?: number;
  product_count?: number;
}

interface Catalog {
  total: number;
  categories: CategoryNode[];
  brands?: { brand: string; count: number }[];
  tags?: { tag: string; count: number }[];
  shops?: { shop_id: number; name: string; count: number }[];
  items: CatalogItem[];
  page: number;
  page_size: number;
  parsed_hints?: string[];
}

interface Campaign {
  campaign_id: number;
  name: string;
  description: string | null;
  ends_at: string;
  coupons: { code: string; discount_type: string; discount_value: number; min_order_amount: number; max_discount: number | null }[];
  products: { product_id: number; name: string; price: number; image_url: string | null; shop: string }[];
}

const PRICE_PRESETS = [
  { label: "≤ ฿200", min: "", max: "200" },
  { label: "฿200–500", min: "200", max: "500" },
  { label: "฿500–1,500", min: "500", max: "1500" },
  { label: "> ฿1,500", min: "1500", max: "" },
] as const;

const SMART_EXAMPLES = [
  "สว่านมากิต้า งบ 3500",
  "น้ำปลา -ทิพรส ราคาถูกสุด",
  "อาหารฮาลาล ไม่ใส่ผงชูรส ไม่เกิน 200",
  "fish sauce",
  "อาหารแมว",
] as const;

export const couponText = (c: { discount_type: string; discount_value: number; min_order_amount: number; max_discount: number | null }) =>
  `${c.discount_type === "PERCENT" ? `${c.discount_value}% off` : `${baht(c.discount_value)} off`}${c.max_discount ? ` (up to ${baht(c.max_discount)})` : ""}${c.min_order_amount > 0 ? ` from ${baht(c.min_order_amount)}` : ""}`;

export function ProductImage({ src, alt, className }: { src: string | null; alt: string; className?: string }) {
  return src ? (
    <img src={src} alt={alt} loading="lazy" className={className ?? "aspect-square w-full rounded-t-lg object-cover"} />
  ) : (
    <div className={(className ?? "aspect-square w-full rounded-t-lg") + " flex items-center justify-center bg-muted text-muted-foreground"}>
      <ImageOff className="size-6" aria-hidden />
    </div>
  );
}

function ProductCard({
  p,
  onQuickAdd,
  added,
  onAskBot,
}: {
  p: CatalogItem;
  onQuickAdd: (p: CatalogItem) => void;
  added: boolean;
  onAskBot: (p: CatalogItem) => void;
}) {
  return (
    <div className="group flex flex-col rounded-lg border bg-card transition-colors duration-150 hover:border-accent/60">
      <Link to={`/products/${p.product_id}`} className="relative block">
        <ProductImage src={p.image_url} alt={p.name} />
        {p.brand && (
          <span className="absolute top-2 left-2 rounded bg-card/90 px-1.5 py-0.5 text-[11px] font-medium shadow-xs">
            {p.brand}
          </span>
        )}
        {p.stock_qty <= 0 && (
          <span className="absolute top-2 right-2 rounded bg-destructive/90 px-1.5 py-0.5 text-[11px] font-semibold text-white">
            หมด
          </span>
        )}
      </Link>
      <div className="flex flex-1 flex-col gap-1.5 p-3">
        <Link to={`/products/${p.product_id}`} className="line-clamp-2 text-sm font-medium group-hover:text-accent">
          {p.name}
        </Link>
        {p.tags && p.tags.length > 0 && (
          <div className="flex flex-wrap gap-1">
            {p.tags.slice(0, 3).map((t) => (
              <span key={t} className="rounded bg-muted px-1.5 py-0.5 text-[10px] text-muted-foreground">
                {TAG_LABEL_MAP[t]?.icon} {TAG_LABEL_MAP[t]?.label ?? t}
              </span>
            ))}
          </div>
        )}
        <div className="mt-auto pt-1">
          <div className="flex items-baseline gap-1.5">
            <span className="text-base font-semibold text-accent">{baht(p.price)}</span>
            {p.unit && <span className="text-[11px] text-muted-foreground">/ {p.unit}</span>}
          </div>
          {(p.pack_qty ?? 1) > 1 && p.unit_price && (
            <div className="text-[11px] text-success">เฉลี่ย {baht(p.unit_price)}/หน่วย</div>
          )}
        </div>
        <div className="flex justify-between gap-2 text-xs text-muted-foreground">
          <span className="truncate">{p.shop}</span>
          <span className="shrink-0">{p.stock_qty > 0 ? `${num(p.sold)} sold` : "Sold out"}</span>
        </div>
        <div className="mt-1 flex items-center gap-1.5">
          <button
            type="button"
            disabled={p.stock_qty <= 0}
            onClick={() => onQuickAdd(p)}
            className="inline-flex h-8 flex-1 items-center justify-center gap-1 rounded-md bg-primary/10 px-2 text-xs font-medium text-primary hover:bg-primary hover:text-primary-foreground disabled:opacity-40"
          >
            {added ? <Check className="size-3.5" /> : <ShoppingCart className="size-3.5" />}
            <span>{added ? "ใส่แล้ว" : "ใส่ตะกร้า"}</span>
          </button>
          <button
            type="button"
            title="ถามน้องเอฟดีเกี่ยวกับสินค้านี้"
            onClick={() => onAskBot(p)}
            className="inline-flex size-8 shrink-0 items-center justify-center rounded-md border text-muted-foreground hover:border-primary hover:text-primary"
          >
            <Bot className="size-3.5" aria-hidden />
          </button>
        </div>
      </div>
    </div>
  );
}

export function CatalogPage() {
  const { id: shopId } = useParams();
  const nav = useNavigate();
  const qc = useQueryClient();
  const { me } = useAuth();
  const { sendMessage } = useBot();
  const [addedId, setAddedId] = useState<number | null>(null);
  const [cartNotice, setCartNotice] = useState<string | null>(null);

  const [f, set] = useUrlState({
    q: "",
    category_id: "",
    brand: "",
    min_price: "",
    max_price: "",
    tags: "",
    in_stock: "",
    sort: "new",
    page: "1",
  });

  const { data, error, isFetching } = useApi<Catalog>("catalog", {
    q: f.q || undefined,
    category_id: f.category_id || undefined,
    brand: f.brand || undefined,
    min_price: f.min_price || undefined,
    max_price: f.max_price || undefined,
    tags: f.tags || undefined,
    in_stock: f.in_stock === "1" ? true : undefined,
    sort: f.sort,
    page: f.page,
    shop_id: shopId,
    page_size: 24,
  });
  const campaigns = useApi<Campaign[]>(shopId ? null : "campaigns");
  const page = Number(f.page) || 1;
  const pages = data ? Math.max(1, Math.ceil(data.total / data.page_size)) : 1;

  if (error) return <ErrorState error={error} />;

  const allCats = data?.categories ?? [];
  const mainCats = allCats.filter((c) => !c.parent_id);
  const selectedCatId = f.category_id ? Number(f.category_id) : null;
  const selectedCat = allCats.find((c) => c.category_id === selectedCatId) ?? null;
  const activeParentId = selectedCat ? (selectedCat.parent_id ?? selectedCat.category_id) : null;
  const subCats = activeParentId ? allCats.filter((c) => c.parent_id === activeParentId) : [];

  const activeTags = f.tags ? f.tags.split(",").filter(Boolean) : [];
  const hasFilters = Boolean(f.q || f.category_id || f.brand || f.min_price || f.max_price || f.tags || f.in_stock);

  function toggleTag(tagId: string) {
    const next = activeTags.includes(tagId) ? activeTags.filter((t) => t !== tagId) : [...activeTags, tagId];
    set({ tags: next.join(",") });
  }

  async function quickAdd(p: CatalogItem) {
    if (!me) {
      nav(`/login?next=${encodeURIComponent(location.pathname + location.search)}`);
      return;
    }
    if (me.role !== "buyer") {
      setCartNotice("เฉพาะบัญชีผู้ซื้อ (Buyer) เท่านั้นที่ใส่ตะกร้าได้ครับ");
      return;
    }
    setCartNotice(null);
    try {
      await apiSend("PUT", `cart/${p.product_id}`, { qty: 1 });
      await qc.invalidateQueries({ queryKey: ["cart"] });
      setAddedId(p.product_id);
      setTimeout(() => setAddedId((cur) => (cur === p.product_id ? null : cur)), 1800);
    } catch (e) {
      setCartNotice(errorText(e));
    }
  }

  function askBotAbout(p: CatalogItem) {
    void sendMessage(`ช่วยแนะนำและสรุปความคุ้มค่าของ "${p.name}" พร้อมคูปองที่ใช้ได้หน่อยครับ`, {
      viewingProductId: p.product_id,
      openDrawer: true,
    });
  }

  const shopName = shopId ? data?.items[0]?.shop : undefined;

  return (
    <>
      {/* Campaign Banner */}
      {!shopId && !f.q && (campaigns.data ?? []).map((c) => (
        <Card key={c.campaign_id} className="mb-4 overflow-hidden border-primary/40">
          <div className="flex flex-wrap items-center gap-3 bg-primary/10 px-4 py-3">
            <Megaphone className="size-5 text-primary" aria-hidden />
            <div className="min-w-0 flex-1">
              <div className="font-semibold">{c.name}</div>
              <div className="text-sm text-muted-foreground">{c.description}</div>
            </div>
            {c.coupons.map((k) => (
              <span key={k.code} className="inline-flex items-center gap-1 rounded-md border border-dashed border-primary px-2 py-1 text-xs">
                <Tag className="size-3.5" aria-hidden />
                <b>{k.code}</b> · {couponText(k)}
              </span>
            ))}
          </div>
          {c.products.length > 0 && (
            <div className="grid grid-cols-2 gap-3 p-3 sm:grid-cols-4">
              {c.products.slice(0, 4).map((p) => (
                <Link key={p.product_id} to={`/products/${p.product_id}`} className="flex items-center gap-2 rounded-md p-1 hover:bg-muted">
                  <ProductImage src={p.image_url} alt={p.name} className="size-12 shrink-0 rounded-md object-cover" />
                  <span className="min-w-0 text-xs">
                    <span className="line-clamp-2">{p.name}</span>
                    <b className="text-accent">{baht(p.price)}</b>
                  </span>
                </Link>
              ))}
            </div>
          )}
        </Card>
      ))}

      {/* Sales Concierge CTA Banner */}
      {!shopId && !f.q && (
        <div className="mb-4 flex flex-wrap items-center justify-between gap-3 rounded-xl border border-primary/30 bg-gradient-to-r from-primary/10 via-card to-card px-4 py-3">
          <div className="flex items-center gap-3">
            <span className="flex size-10 shrink-0 items-center justify-center rounded-lg bg-primary text-primary-foreground">
              <Sparkles className="size-5" aria-hidden />
            </span>
            <div>
              <div className="text-sm font-semibold">ไม่รู้จะเลือกตัวไหน? คุยกับ &quot;น้องเอฟดี&quot; ผู้ช่วยค้นหาและปิดการขาย</div>
              <div className="text-xs text-muted-foreground">
                พิมพ์งบ แบรนด์ หรือแท็กเช่น &quot;สว่านมากิต้า งบ 3500&quot; · เปรียบเทียบราคาต่อหน่วย · สั่งหยิบใส่ตะกร้าทันที
              </div>
            </div>
          </div>
          <Link
            to="/assistant"
            className="inline-flex h-9 shrink-0 items-center gap-1.5 rounded-md bg-primary px-3.5 text-xs font-semibold text-primary-foreground hover:bg-primary/90"
          >
            <Bot className="size-4" aria-hidden /> เปิดห้องคุย Sales Cockpit
          </Link>
        </div>
      )}

      {/* Main Category Pills Bar */}
      {!shopId && mainCats.length > 0 && (
        <div className="mb-3 space-y-2">
          <div className="flex gap-2 overflow-x-auto pb-1">
            <button
              type="button"
              onClick={() => set({ category_id: "" })}
              className={cx(
                "shrink-0 rounded-full border px-3 py-1.5 text-xs font-medium transition-colors",
                !f.category_id ? "border-primary bg-primary text-primary-foreground" : "bg-card hover:border-primary/50",
              )}
            >
              ทั้งหมด
            </button>
            {mainCats.map((c) => {
              const active = activeParentId === c.category_id;
              return (
                <button
                  key={c.category_id}
                  type="button"
                  onClick={() => set({ category_id: active && !selectedCat?.parent_id ? "" : c.category_id })}
                  className={cx(
                    "inline-flex shrink-0 items-center gap-1.5 rounded-full border px-3 py-1.5 text-xs font-medium transition-colors",
                    active ? "border-primary bg-primary text-primary-foreground" : "bg-card hover:border-primary/50",
                  )}
                >
                  {c.icon && <span>{c.icon}</span>}
                  <span>{c.name_th || c.name}</span>
                  {c.product_count !== undefined && (
                    <span className={cx("text-[10px]", active ? "opacity-80" : "text-muted-foreground")}>({c.product_count})</span>
                  )}
                </button>
              );
            })}
          </div>
          {subCats.length > 0 && (
            <div className="flex flex-wrap items-center gap-1.5 rounded-lg bg-muted/40 px-3 py-2">
              <span className="text-[11px] font-medium text-muted-foreground">หมวดย่อย:</span>
              <button
                type="button"
                onClick={() => set({ category_id: activeParentId })}
                className={cx(
                  "rounded-md px-2.5 py-1 text-xs font-medium",
                  selectedCatId === activeParentId ? "bg-primary text-primary-foreground" : "bg-card hover:bg-muted",
                )}
              >
                ทั้งหมดในหมวดนี้
              </button>
              {subCats.map((sc) => {
                const active = selectedCatId === sc.category_id;
                return (
                  <button
                    key={sc.category_id}
                    type="button"
                    onClick={() => set({ category_id: sc.category_id })}
                    className={cx(
                      "inline-flex items-center gap-1 rounded-md px-2.5 py-1 text-xs font-medium",
                      active ? "bg-primary text-primary-foreground" : "bg-card hover:bg-muted",
                    )}
                  >
                    {sc.icon && <span>{sc.icon}</span>}
                    <span>{sc.name_th || sc.name}</span>
                    {sc.product_count !== undefined && <span className="text-[10px] opacity-75">({sc.product_count})</span>}
                  </button>
                );
              })}
            </div>
          )}
        </div>
      )}

      {/* Smart Query Examples + Parsed Hints */}
      <div className="mb-3 flex flex-wrap items-center gap-1.5 text-xs">
        <span className="text-muted-foreground">ลองค้นอัจฉริยะ:</span>
        {SMART_EXAMPLES.map((ex) => (
          <button
            key={ex}
            type="button"
            onClick={() => set({ q: ex })}
            className="rounded-full border bg-card px-2.5 py-0.5 text-[11px] text-muted-foreground hover:border-primary hover:text-foreground"
          >
            {ex}
          </button>
        ))}
      </div>

      {data?.parsed_hints && data.parsed_hints.length > 0 && (
        <div className="mb-3 flex flex-wrap items-center gap-1.5 rounded-lg border border-primary/30 bg-primary/5 px-3 py-2 text-xs">
          <Sparkles className="size-3.5 text-primary" aria-hidden />
          <span className="font-medium">Smart Search เข้าใจว่า:</span>
          {data.parsed_hints.map((h) => (
            <span key={h} className="rounded bg-primary/15 px-2 py-0.5 text-[11px] font-medium text-primary">
              {h}
            </span>
          ))}
        </div>
      )}

      <PageHeader
        title={shopId ? shopName ?? "Shop" : f.q ? `ผลการค้นหา "${f.q}"` : selectedCat ? (selectedCat.name_th || selectedCat.name) : "สินค้าทั้งหมด"}
        description={data ? `${num(data.total)} รายการ` : " "}
        actions={
          hasFilters ? (
            <button
              type="button"
              onClick={() => set({ q: "", category_id: "", brand: "", min_price: "", max_price: "", tags: "", in_stock: "", sort: "new" })}
              className="inline-flex h-8 items-center gap-1 rounded-md border px-2.5 text-xs hover:bg-muted"
            >
              <RotateCcw className="size-3.5" /> ล้างตัวกรองทั้งหมด
            </button>
          ) : undefined
        }
      />

      {/* Facet Filter Bar */}
      <Card className="mb-4 space-y-3 p-3.5">
        <div className="flex flex-wrap items-end gap-3">
          <Select
            label="แบรนด์ / ยี่ห้อ"
            value={f.brand}
            onChange={(e) => set({ brand: e.target.value })}
            options={[
              { value: "", label: "ทุกแบรนด์" },
              ...(data?.brands ?? []).map((b) => ({ value: b.brand, label: `${b.brand} (${b.count})` })),
            ]}
          />
          <Select
            label="เรียงลำดับ"
            value={f.sort}
            onChange={(e) => set({ sort: e.target.value })}
            options={[
              { value: "new", label: "มาใหม่ล่าสุด" },
              { value: "popular", label: "ขายดีที่สุด" },
              { value: "price_asc", label: "ราคา: ต่ำ → สูง" },
              { value: "price_desc", label: "ราคา: สูง → ต่ำ" },
              { value: "unit_price_asc", label: "ราคาต่อหน่วยคุ้มสุด" },
            ]}
          />
          <div className="flex flex-col gap-1">
            <span className="text-xs font-medium text-muted-foreground">ช่วงราคา (บาท)</span>
            <div className="flex flex-wrap items-center gap-1.5">
              {PRICE_PRESETS.map((pr) => {
                const active = f.min_price === pr.min && f.max_price === pr.max;
                return (
                  <button
                    key={pr.label}
                    type="button"
                    onClick={() => set(active ? { min_price: "", max_price: "" } : { min_price: pr.min, max_price: pr.max })}
                    className={cx(
                      "h-9 rounded-md border px-2.5 text-xs font-medium",
                      active ? "border-primary bg-primary text-primary-foreground" : "bg-background hover:bg-muted",
                    )}
                  >
                    {pr.label}
                  </button>
                );
              })}
            </div>
          </div>
          <label className="inline-flex h-9 items-center gap-2 rounded-md border px-3 text-xs font-medium">
            <input
              type="checkbox"
              checked={f.in_stock === "1"}
              onChange={(e) => set({ in_stock: e.target.checked ? "1" : "" })}
            />
            มีสต็อกพร้อมส่ง
          </label>
        </div>

        {/* Trait Quick Chips */}
        <div className="flex flex-wrap items-center gap-1.5 border-t pt-2.5">
          <span className="mr-1 text-xs font-medium text-muted-foreground">คุณลักษณะ:</span>
          {TRAIT_CHIPS.map((chip) => {
            const active = activeTags.includes(chip.id);
            return (
              <button
                key={chip.id}
                type="button"
                onClick={() => toggleTag(chip.id)}
                className={cx(
                  "inline-flex items-center gap-1 rounded-full border px-2.5 py-1 text-xs font-medium transition-colors",
                  active ? "border-primary bg-primary text-primary-foreground" : "bg-background text-muted-foreground hover:border-primary/50 hover:text-foreground",
                )}
              >
                <span>{chip.icon}</span>
                <span>{chip.label}</span>
              </button>
            );
          })}
        </div>
      </Card>

      {cartNotice && <p role="alert" className="mb-3 text-sm text-destructive">{cartNotice}</p>}

      <div className={"grid grid-cols-2 gap-3 transition-opacity sm:grid-cols-3 lg:grid-cols-4 " + (isFetching ? "opacity-60" : "")}>
        {data?.items.map((p) => (
          <ProductCard key={p.product_id} p={p} onQuickAdd={(it) => void quickAdd(it)} added={addedId === p.product_id} onAskBot={askBotAbout} />
        ))}
      </div>

      {data && data.total === 0 && (
        <div className="space-y-3 py-12 text-center text-sm text-muted-foreground">
          <p>ไม่พบสินค้าที่ตรงกับเงื่อนไขนี้</p>
          {f.q && (
            <button
              type="button"
              onClick={() => void sendMessage(f.q, { openDrawer: true })}
              className="inline-flex items-center gap-1.5 rounded-md bg-primary px-3.5 py-2 text-xs font-medium text-primary-foreground"
            >
              <Bot className="size-4" /> ให้น้องเอฟดีช่วยหาตัวเลือกใกล้เคียง
            </button>
          )}
        </div>
      )}

      {pages > 1 && (
        <div className="mt-5 flex items-center justify-center gap-3 text-sm">
          <button type="button" className="rounded-md border px-3 py-1.5 disabled:opacity-50" disabled={page <= 1} onClick={() => set({ page: page - 1 })}>
            ก่อนหน้า
          </button>
          <span>หน้า {page} จาก {pages}</span>
          <button type="button" className="rounded-md border px-3 py-1.5 disabled:opacity-50" disabled={page >= pages} onClick={() => set({ page: page + 1 })}>
            ถัดไป
          </button>
        </div>
      )}
    </>
  );
}
