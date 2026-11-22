import { useQueryClient } from "@tanstack/react-query";
import { Bot, Minus, Plus, ShoppingCart, Store, Tag } from "lucide-react";
import { useState } from "react";
import { Link, useNavigate, useParams } from "react-router";
import { TAG_LABEL_MAP, useBot } from "../components/BotContext";
import { Badge, Card, ErrorState, PageSkeleton } from "../components/ui";
import { apiSend, errorText, useApi } from "../lib/api";
import { useAuth } from "../lib/auth";
import { baht, num } from "../lib/format";
import { couponText, ProductImage } from "./Catalog";

interface RelatedProduct {
  product_id: number;
  name: string;
  price: number;
  image_url: string | null;
  stock_qty: number;
  brand?: string | null;
  unit?: string | null;
  pack_qty?: number | null;
  shop_id: number;
  shop: string;
}

interface Product {
  product_id: number;
  name: string;
  description: string | null;
  price: number;
  unit_price?: number;
  image_url: string | null;
  stock_qty: number;
  category: string | null;
  category_th?: string | null;
  parent_category?: string | null;
  parent_category_th?: string | null;
  brand?: string | null;
  sku?: string | null;
  barcode?: string | null;
  unit?: string | null;
  pack_qty?: number | null;
  tags?: string[];
  shop: { shop_id: number; name: string; description: string | null };
  shop_coupons: { code: string; discount_type: string; discount_value: number; min_order_amount: number; max_discount: number | null; expires_at: string }[];
  related?: RelatedProduct[];
}

export function ProductPage() {
  const { id } = useParams();
  const { me } = useAuth();
  const nav = useNavigate();
  const qc = useQueryClient();
  const { sendMessage } = useBot();
  const { data: p, error } = useApi<Product>(`products/${id}`);
  const [qty, setQty] = useState(1);
  const [msg, setMsg] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  if (error) return <ErrorState error={error} />;
  if (!p) return <PageSkeleton />;
  const product = p;

  async function add() {
    if (!me) {
      nav(`/login?next=/products/${id}`);
      return;
    }
    setBusy(true);
    setMsg(null);
    try {
      await apiSend("PUT", `cart/${product.product_id}`, { qty });
      await qc.invalidateQueries({ queryKey: ["cart"] });
      setMsg("Added to your cart.");
    } catch (e) {
      setMsg(errorText(e));
    } finally {
      setBusy(false);
    }
  }

  const out = p.stock_qty <= 0;
  return (
    <div className="space-y-8">
      <div className="grid gap-6 md:grid-cols-2">
        <ProductImage src={p.image_url} alt={p.name} className="aspect-square w-full rounded-lg border object-cover" />
        <div className="space-y-4">
          <div>
            <div className="text-xs text-muted-foreground">
              {p.parent_category_th || p.parent_category ? `${p.parent_category_th || p.parent_category} › ` : ""}
              {p.category_th || p.category || "ทั่วไป"}
            </div>
            <h1 className="text-xl font-semibold">{p.name}</h1>
            <div className="mt-1 flex flex-wrap items-center gap-2 text-xs text-muted-foreground">
              {p.brand && <span>แบรนด์: <b className="text-foreground">{p.brand}</b></span>}
              {p.sku && <span>SKU: <code className="font-mono">{p.sku}</code></span>}
              {p.barcode && <span>บาร์โค้ด: <code className="font-mono">{p.barcode}</code></span>}
            </div>
            <div className="mt-2 flex items-baseline gap-2">
              <span className="text-2xl font-semibold text-accent">{baht(p.price)}</span>
              {p.unit && <span className="text-sm text-muted-foreground">/ {p.unit}</span>}
            </div>
            {(p.pack_qty ?? 1) > 1 && p.unit_price && (
              <div className="text-xs text-success">บรรจุ {p.pack_qty} หน่วย · เฉลี่ย {baht(p.unit_price)} ต่อหน่วย</div>
            )}
            <div className="mt-1 text-sm text-muted-foreground">{out ? "Sold out" : `${num(p.stock_qty)} in stock`}</div>
          </div>

          {p.tags && p.tags.length > 0 && (
            <div className="flex flex-wrap gap-1.5">
              {p.tags.map((t) => (
                <Badge key={t} tone="neutral">
                  {TAG_LABEL_MAP[t]?.icon} {TAG_LABEL_MAP[t]?.label ?? t}
                </Badge>
              ))}
            </div>
          )}

          {p.shop_coupons.length > 0 && (
            <div className="flex flex-wrap gap-2">
              {p.shop_coupons.map((c) => (
                <span key={c.code} className="inline-flex items-center gap-1 rounded-md border border-dashed border-primary px-2 py-1 text-xs">
                  <Tag className="size-3.5" aria-hidden />
                  <b>{c.code}</b> · {couponText(c)}
                </span>
              ))}
            </div>
          )}

          {me?.role !== "seller" && me?.role !== "admin" && (
            <div className="flex flex-wrap items-center gap-3">
              <div className="inline-flex items-center rounded-md border">
                <button type="button" aria-label="Fewer" className="inline-flex size-9 items-center justify-center disabled:opacity-40" disabled={qty <= 1} onClick={() => setQty(qty - 1)}>
                  <Minus className="size-4" aria-hidden />
                </button>
                <span className="w-10 text-center text-sm tabular-nums" aria-live="polite">{qty}</span>
                <button type="button" aria-label="More" className="inline-flex size-9 items-center justify-center disabled:opacity-40" disabled={qty >= Math.min(99, p.stock_qty)} onClick={() => setQty(qty + 1)}>
                  <Plus className="size-4" aria-hidden />
                </button>
              </div>
              <button type="button" disabled={busy || out} onClick={add} className="inline-flex h-10 items-center gap-2 rounded-md bg-primary px-4 text-sm font-medium text-primary-foreground hover:bg-primary/90 disabled:opacity-50">
                <ShoppingCart className="size-4" aria-hidden /> Add to cart
              </button>
              <button
                type="button"
                onClick={() =>
                  void sendMessage(`ช่วยสรุปจุดเด่นของ "${p.name}" และเทียบกับตัวเลือกอื่นในหมวดเดียวกันให้หน่อยครับ`, {
                    viewingProductId: p.product_id,
                    openDrawer: true,
                  })
                }
                className="inline-flex h-10 items-center gap-1.5 rounded-md border px-3 text-sm font-medium hover:border-primary hover:text-primary"
              >
                <Bot className="size-4" aria-hidden /> ถามน้องเอฟดี
              </button>
              {msg && (
                <span role="status" className="text-sm">
                  {msg} {msg.startsWith("Added") && <Link to="/cart" className="text-accent underline">View cart</Link>}
                </span>
              )}
            </div>
          )}

          {p.description && <p className="text-sm leading-relaxed">{p.description}</p>}
          <Card className="p-3">
            <Link to={`/shops/${p.shop.shop_id}`} className="flex items-center gap-2 font-medium hover:text-accent">
              <Store className="size-4" aria-hidden />
              {p.shop.name}
            </Link>
            {p.shop.description && <p className="mt-1 text-xs text-muted-foreground">{p.shop.description}</p>}
          </Card>
        </div>
      </div>

      {p.related && p.related.length > 0 && (
        <section className="space-y-3">
          <h2 className="text-base font-semibold">สินค้าที่เกี่ยวข้อง</h2>
          <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
            {p.related.map((r) => (
              <Link key={r.product_id} to={`/products/${r.product_id}`} className="group flex flex-col rounded-lg border bg-card transition-colors hover:border-accent/60">
                <ProductImage src={r.image_url} alt={r.name} />
                <div className="flex flex-1 flex-col gap-1 p-2.5">
                  <div className="line-clamp-2 text-xs font-medium group-hover:text-accent">{r.name}</div>
                  <div className="mt-auto text-sm font-semibold text-accent">{baht(r.price)}</div>
                  <div className="truncate text-[11px] text-muted-foreground">{r.shop}</div>
                </div>
              </Link>
            ))}
          </div>
        </section>
      )}
    </div>
  );
}
