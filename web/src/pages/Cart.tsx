import { useQueryClient } from "@tanstack/react-query";
import { Loader2, Minus, Plus, Store, Trash2 } from "lucide-react";
import { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router";
import { Card, CardHeader, DefinitionList, ErrorState, PageHeader, PageSkeleton } from "../components/ui";
import { apiSend, errorText, useApi } from "../lib/api";
import { baht } from "../lib/format";

export interface Priced {
  shop_id: number; shop: string; subtotal: number; discount: number; shipping_fee: number; total: number;
  coupon: { ok: boolean; message?: string; code?: string; platform?: boolean } | null;
  items: { product_id: number; name: string; unit_price: number; qty: number; line_total: number; stock_qty: number; available: boolean }[];
}
const input = "h-9 w-full rounded-md border bg-card px-2.5 text-sm focus-visible:outline-2 focus-visible:outline-ring";

function ShopCheckout({ group }: { group: Priced }) {
  const qc = useQueryClient();
  const nav = useNavigate();
  const [coupon, setCoupon] = useState("");
  const [quote, setQuote] = useState<Priced>(group);
  const [addr, setAddr] = useState({ ship_name: "", ship_phone: "", ship_address: "" });
  const [busy, setBusy] = useState(false);
  const [err, setErr] = useState<string | null>(null);
  useEffect(() => setQuote(group), [group]);

  async function setQty(product_id: number, qty: number) {
    setErr(null);
    try { await apiSend("PUT", `cart/${product_id}`, { qty }); await qc.invalidateQueries({ queryKey: ["cart"] }); } catch (e) { setErr(errorText(e)); }
  }
  async function applyCoupon() {
    setErr(null);
    try { setQuote(await apiSend<Priced>("POST", "checkout/quote", { shop_id: group.shop_id, coupon: coupon || null })); } catch (e) { setErr(errorText(e)); }
  }
  async function checkout() {
    setBusy(true); setErr(null);
    try {
      const o = await apiSend<{ order_id: number }>("POST", "checkout", { shop_id: group.shop_id, coupon: coupon || null, ...addr });
      await qc.invalidateQueries({ queryKey: ["cart"] });
      nav(`/orders/${o.order_id}`);
    } catch (e) { setErr(errorText(e)); } finally { setBusy(false); }
  }
  const blocked = quote.items.some((i) => !i.available);
  return (
    <Card>
      <CardHeader title={group.shop} description="One order per shop" actions={<Link to={`/shops/${group.shop_id}`} className="inline-flex items-center gap-1 text-xs text-accent"><Store className="size-3.5" aria-hidden />Visit shop</Link>} />
      <ul className="divide-y">
        {group.items.map((i) => (
          <li key={i.product_id} className="flex flex-wrap items-center gap-3 px-4 py-3">
            <Link to={`/products/${i.product_id}`} className="min-w-0 flex-1 text-sm hover:text-accent">{i.name}
              <div className="text-xs text-muted-foreground">{baht(i.unit_price)} each{!i.available && <span className="ml-2 text-destructive">only {i.stock_qty} left</span>}</div></Link>
            <div className="inline-flex items-center rounded-md border">
              <button type="button" aria-label={`Fewer ${i.name}`} className="inline-flex size-8 items-center justify-center" onClick={() => setQty(i.product_id, i.qty - 1)}><Minus className="size-3.5" aria-hidden /></button>
              <span className="w-8 text-center text-sm tabular-nums">{i.qty}</span>
              <button type="button" aria-label={`More ${i.name}`} className="inline-flex size-8 items-center justify-center" onClick={() => setQty(i.product_id, i.qty + 1)}><Plus className="size-3.5" aria-hidden /></button>
            </div>
            <span className="w-24 text-right text-sm tabular-nums">{baht(i.line_total)}</span>
            <button type="button" aria-label={`Remove ${i.name}`} className="inline-flex size-8 items-center justify-center rounded-md hover:bg-muted" onClick={() => setQty(i.product_id, 0)}><Trash2 className="size-4" aria-hidden /></button>
          </li>
        ))}
      </ul>
      <div className="grid gap-4 border-t p-4 md:grid-cols-2">
        <div className="space-y-2">
          <div className="flex gap-2">
            <input aria-label="Coupon code" value={coupon} onChange={(e) => setCoupon(e.target.value.toUpperCase())} placeholder="Coupon code" className={input} />
            <button type="button" onClick={applyCoupon} className="h-9 shrink-0 rounded-md border px-3 text-sm font-medium hover:bg-muted">Apply</button>
          </div>
          {quote.coupon?.message && coupon && <p className={"text-xs " + (quote.coupon.ok ? "text-success" : "text-destructive")}>{quote.coupon.message}{quote.coupon.platform ? " (platform campaign)" : ""}</p>}
          <input aria-label="Recipient name" placeholder="Recipient name" className={input} value={addr.ship_name} onChange={(e) => setAddr({ ...addr, ship_name: e.target.value })} />
          <input aria-label="Phone" placeholder="Phone (e.g. 0812345678)" inputMode="tel" className={input} value={addr.ship_phone} onChange={(e) => setAddr({ ...addr, ship_phone: e.target.value })} />
          <textarea aria-label="Delivery address" placeholder="Full delivery address" rows={2} className={input + " h-auto py-2"} value={addr.ship_address} onChange={(e) => setAddr({ ...addr, ship_address: e.target.value })} />
        </div>
        <div>
          <DefinitionList items={[["Subtotal", baht(quote.subtotal)], ["Discount", quote.discount ? `−${baht(quote.discount)}` : "—"],
            ["Shipping", quote.shipping_fee ? baht(quote.shipping_fee) : "Free"], ["Total (from the server)", <b>{baht(quote.total)}</b>]]} />
          <p className="px-4 text-xs text-muted-foreground">Shipping ฿40, free from ฿500 after discount. Pay by bank transfer within 24 hours.</p>
          {err && <p role="alert" className="px-4 pt-2 text-sm text-destructive">{err}</p>}
          <div className="p-4 pt-3">
            <button type="button" disabled={busy || blocked} onClick={checkout} className="inline-flex h-10 w-full items-center justify-center gap-2 rounded-md bg-primary text-sm font-medium text-primary-foreground disabled:opacity-50">
              {busy && <Loader2 className="size-4 animate-spin" aria-hidden />} Place order</button>
          </div>
        </div>
      </div>
    </Card>
  );
}

export function CartPage() {
  const { data, error } = useApi<Priced[]>("cart");
  if (error) return <ErrorState error={error} />;
  if (!data) return <PageSkeleton />;
  return (
    <>
      <PageHeader title="Cart" description="Grouped by shop. Prices, coupons and totals are checked by the server when you order." />
      {data.length === 0 ? <p className="py-10 text-center text-sm text-muted-foreground">Your cart is empty. <Link to="/" className="text-accent underline">Browse products</Link></p>
        : <div className="space-y-4">{data.map((g) => <ShopCheckout key={g.shop_id} group={g} />)}</div>}
    </>
  );
}
