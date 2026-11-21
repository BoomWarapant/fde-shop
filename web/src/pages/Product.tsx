import { useQueryClient } from "@tanstack/react-query";
import { Minus, Plus, ShoppingCart, Store, Tag } from "lucide-react";
import { useState } from "react";
import { Link, useNavigate, useParams } from "react-router";
import { Card, ErrorState, PageSkeleton } from "../components/ui";
import { apiSend, errorText, useApi } from "../lib/api";
import { useAuth } from "../lib/auth";
import { baht, num } from "../lib/format";
import { couponText, ProductImage } from "./Catalog";

interface Product { product_id: number; name: string; description: string | null; price: number; image_url: string | null; stock_qty: number;
  category: string | null; shop: { shop_id: number; name: string; description: string | null };
  shop_coupons: { code: string; discount_type: string; discount_value: number; min_order_amount: number; max_discount: number | null; expires_at: string }[] }

export function ProductPage() {
  const { id } = useParams();
  const { me } = useAuth();
  const nav = useNavigate();
  const qc = useQueryClient();
  const { data: p, error } = useApi<Product>(`products/${id}`);
  const [qty, setQty] = useState(1);
  const [msg, setMsg] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  if (error) return <ErrorState error={error} />;
  if (!p) return <PageSkeleton />;
  const product = p;
  async function add() {
    if (!me) { nav(`/login?next=/products/${id}`); return; }
    setBusy(true); setMsg(null);
    try {
      await apiSend("PUT", `cart/${product.product_id}`, { qty });
      await qc.invalidateQueries({ queryKey: ["cart"] });
      setMsg("Added to your cart.");
    } catch (e) { setMsg(errorText(e)); } finally { setBusy(false); }
  }
  const out = p.stock_qty <= 0;
  return (
    <div className="grid gap-6 md:grid-cols-2">
      <ProductImage src={p.image_url} alt={p.name} className="aspect-square w-full rounded-lg border object-cover" />
      <div className="space-y-4">
        <div>
          <div className="text-xs text-muted-foreground">{p.category}</div>
          <h1 className="text-xl font-semibold">{p.name}</h1>
          <div className="mt-2 text-2xl font-semibold text-accent">{baht(p.price)}</div>
          <div className="text-sm text-muted-foreground">{out ? "Sold out" : `${num(p.stock_qty)} in stock`}</div>
        </div>
        {p.shop_coupons.length > 0 && (
          <div className="flex flex-wrap gap-2">{p.shop_coupons.map((c) => <span key={c.code} className="inline-flex items-center gap-1 rounded-md border border-dashed border-primary px-2 py-1 text-xs"><Tag className="size-3.5" aria-hidden /><b>{c.code}</b> · {couponText(c)}</span>)}</div>
        )}
        {me?.role !== "seller" && me?.role !== "admin" && (
          <div className="flex flex-wrap items-center gap-3">
            <div className="inline-flex items-center rounded-md border">
              <button type="button" aria-label="Fewer" className="inline-flex size-9 items-center justify-center disabled:opacity-40" disabled={qty <= 1} onClick={() => setQty(qty - 1)}><Minus className="size-4" aria-hidden /></button>
              <span className="w-10 text-center text-sm tabular-nums" aria-live="polite">{qty}</span>
              <button type="button" aria-label="More" className="inline-flex size-9 items-center justify-center disabled:opacity-40" disabled={qty >= Math.min(99, p.stock_qty)} onClick={() => setQty(qty + 1)}><Plus className="size-4" aria-hidden /></button>
            </div>
            <button type="button" disabled={busy || out} onClick={add} className="inline-flex h-10 items-center gap-2 rounded-md bg-primary px-4 text-sm font-medium text-primary-foreground hover:bg-primary/90 disabled:opacity-50">
              <ShoppingCart className="size-4" aria-hidden /> Add to cart
            </button>
            {msg && <span role="status" className="text-sm">{msg} {msg.startsWith("Added") && <Link to="/cart" className="text-accent underline">View cart</Link>}</span>}
          </div>
        )}
        {p.description && <p className="text-sm leading-relaxed">{p.description}</p>}
        <Card className="p-3">
          <Link to={`/shops/${p.shop.shop_id}`} className="flex items-center gap-2 font-medium hover:text-accent"><Store className="size-4" aria-hidden />{p.shop.name}</Link>
          {p.shop.description && <p className="mt-1 text-xs text-muted-foreground">{p.shop.description}</p>}
        </Card>
      </div>
    </div>
  );
}
