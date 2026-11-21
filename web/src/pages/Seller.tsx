import { useQueryClient } from "@tanstack/react-query";
import { AlertTriangle, Loader2, Plus } from "lucide-react";
import { useState, type FormEvent } from "react";
import { Link } from "react-router";
import { DataTable } from "../components/DataTable";
import { Badge, Card, CardHeader, cx, DefinitionList, ErrorState, Kpi, PageHeader, PageSkeleton, Tabs } from "../components/ui";
import { apiSend, errorText, useApi, useUrlState } from "../lib/api";
import { baht, num } from "../lib/format";
import { couponText } from "./Catalog";
import { OrdersTable, STATUSES, statusLabel, when } from "./Orders";

const input = "h-9 w-full rounded-md border bg-card px-2.5 text-sm focus-visible:outline-2 focus-visible:outline-ring";
const btn = "inline-flex h-9 items-center justify-center gap-1.5 rounded-md px-3 text-sm font-medium disabled:opacity-50";
const label = "block text-xs font-medium text-muted-foreground";

// ---------------------------------------------------------------- overview
interface Overview { shop: { name: string }; orders_by_status: Record<string, number>; sales_30d: number; slips_to_check: number; refunds_to_decide: number;
  low_stock: { product_id: number; name: string; stock_qty: number; low_stock_threshold: number }[] }

export function SellerHomePage() {
  const { data, error } = useApi<Overview>("seller/overview");
  if (error) return <ErrorState error={error} />;
  if (!data) return <PageSkeleton />;
  const s = data.orders_by_status;
  return (
    <>
      <PageHeader title={data.shop.name} description="Seller Center" />
      <div className="mb-4 grid grid-cols-2 gap-3 lg:grid-cols-4">
        <Kpi label="Sales, last 30 days" value={baht(data.sales_30d)} to="/seller/accounting" sub="Paid orders, after shop discounts" />
        <Kpi label="Slips to check" value={num(data.slips_to_check)} to="/seller/orders?status=PENDING_PAYMENT" tone={data.slips_to_check ? "warning" : undefined} sub={`${num(s.PENDING_PAYMENT ?? 0)} orders to be paid`} />
        <Kpi label="To ship" value={num(s.TO_SHIP ?? 0)} to="/seller/orders?status=TO_SHIP" tone={s.TO_SHIP ? "warning" : undefined} sub={`${num(s.SHIPPED ?? 0)} on the way`} />
        <Kpi label="Refund requests" value={num(data.refunds_to_decide)} to="/seller/orders" tone={data.refunds_to_decide ? "danger" : undefined} sub={`${num(s.DELIVERED ?? 0)} delivered`} />
      </div>
      <Card>
        <CardHeader title="Low stock" description="At or below the alert level you set per product" actions={<Link to="/seller/products" className="text-xs text-accent">Manage stock</Link>} />
        {data.low_stock.length === 0 ? <p className="p-4 text-sm text-muted-foreground">Nothing is low.</p> : (
          <ul className="divide-y">{data.low_stock.map((p) => (
            <li key={p.product_id} className="flex items-center justify-between gap-2 px-4 py-2 text-sm">
              <span className="flex items-center gap-2"><AlertTriangle className={cx("size-4", p.stock_qty === 0 ? "text-destructive" : "text-warning")} aria-hidden />{p.name}</span>
              <span className="tabular-nums">{num(p.stock_qty)} left (alert at {num(p.low_stock_threshold)})</span>
            </li>))}
          </ul>
        )}
      </Card>
    </>
  );
}

// ---------------------------------------------------------------- products and stock
interface SellerProduct { product_id: number; name: string; description: string | null; category_id: number | null; category: string | null; price: number;
  image_url: string | null; stock_qty: number; low_stock_threshold: number; is_active: boolean; low: boolean; sold: number; revenue: number }
interface Move { movement_id: number; qty_change: number; reason: string; note: string | null; created_at: string }

function ProductForm({ p, categories, onDone }: { p?: SellerProduct; categories: { category_id: number; name: string }[]; onDone: () => void }) {
  const [busy, setBusy] = useState(false);
  const [err, setErr] = useState<string | null>(null);
  async function submit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const f = new FormData(e.currentTarget);
    const body = { name: f.get("name"), description: f.get("description") || null, category_id: f.get("category_id") ? Number(f.get("category_id")) : null,
      price: f.get("price"), image_url: f.get("image_url") || null, low_stock_threshold: Number(f.get("low_stock_threshold")), is_active: f.get("is_active") === "on",
      initial_stock: p ? 0 : Number(f.get("initial_stock") || 0) };
    setBusy(true); setErr(null);
    try { await apiSend(p ? "PUT" : "POST", p ? `seller/products/${p.product_id}` : "seller/products", body); onDone(); } catch (x) { setErr(errorText(x)); } finally { setBusy(false); }
  }
  return (
    <form onSubmit={submit} className="grid gap-3 p-4 sm:grid-cols-2">
      <label className={cx(label, "sm:col-span-2")}>Name<input name="name" required minLength={2} defaultValue={p?.name} className={input} /></label>
      <label className={label}>Price (THB)<input name="price" type="number" step="0.01" min="0.01" required defaultValue={p?.price} className={input} /></label>
      <label className={label}>Category<select name="category_id" defaultValue={p?.category_id ?? ""} className={input}><option value="">—</option>{categories.map((c) => <option key={c.category_id} value={c.category_id}>{c.name}</option>)}</select></label>
      {!p && <label className={label}>Opening stock<input name="initial_stock" type="number" min="0" defaultValue={0} className={input} /></label>}
      <label className={label}>Low-stock alert at<input name="low_stock_threshold" type="number" min="0" defaultValue={p?.low_stock_threshold ?? 5} className={input} /></label>
      <label className={cx(label, "sm:col-span-2")}>Image link (https://)<input name="image_url" type="url" defaultValue={p?.image_url ?? ""} className={input} /></label>
      <label className={cx(label, "sm:col-span-2")}>Description<textarea name="description" rows={2} defaultValue={p?.description ?? ""} className={input + " h-auto py-2"} /></label>
      <label className="flex items-center gap-2 text-sm"><input type="checkbox" name="is_active" defaultChecked={p?.is_active ?? true} />For sale</label>
      {err && <p role="alert" className="text-sm text-destructive sm:col-span-2">{err}</p>}
      <div className="sm:col-span-2"><button disabled={busy} className={cx(btn, "bg-primary text-primary-foreground")}>{busy && <Loader2 className="size-4 animate-spin" aria-hidden />}{p ? "Save product" : "Add product"}</button></div>
    </form>
  );
}

function StockPanel({ p, onDone }: { p: SellerProduct; onDone: () => void }) {
  const moves = useApi<Move[]>(`seller/products/${p.product_id}/movements`);
  const [change, setChange] = useState("");
  const [note, setNote] = useState("");
  const [err, setErr] = useState<string | null>(null);
  async function go(reason: "RESTOCK" | "ADJUST") {
    setErr(null);
    try { await apiSend("POST", `seller/products/${p.product_id}/stock`, { change: Number(change), reason, note: note || null }); setChange(""); setNote(""); onDone(); await moves.refetch(); } catch (x) { setErr(errorText(x)); }
  }
  return (
    <div className="space-y-3 p-4">
      <div className="flex flex-wrap items-end gap-2">
        <label className={label}>Quantity (+ / −)<input type="number" value={change} onChange={(e) => setChange(e.target.value)} className={input + " w-32"} /></label>
        <label className={cx(label, "min-w-40 flex-1")}>Note<input value={note} onChange={(e) => setNote(e.target.value)} className={input} /></label>
        <button type="button" className={cx(btn, "bg-primary text-primary-foreground")} disabled={!(Number(change) > 0)} onClick={() => go("RESTOCK")}>Restock</button>
        <button type="button" className={cx(btn, "border")} disabled={!Number(change)} onClick={() => go("ADJUST")}>Adjust</button>
      </div>
      {err && <p role="alert" className="text-sm text-destructive">{err}</p>}
      <DataTable caption="Stock movements" dense rows={moves.data} rowKey={(m) => m.movement_id}
        columns={[{ key: "created_at", header: "When", render: (m) => when(m.created_at) }, { key: "reason", header: "Reason" },
          { key: "qty_change", header: "Change", align: "right", render: (m) => <span className={m.qty_change < 0 ? "text-destructive" : "text-success"}>{m.qty_change > 0 ? "+" : ""}{m.qty_change}</span> },
          { key: "note", header: "Note", render: (m) => m.note ?? "" }]} />
    </div>
  );
}

export function SellerProductsPage() {
  const qc = useQueryClient();
  const { data, error } = useApi<SellerProduct[]>("seller/products");
  const cats = useApi<{ categories: { category_id: number; name: string }[] }>("catalog", { page_size: 1 });
  const [open, setOpen] = useState<string | null>(null); // "new" | "edit:<id>" | "stock:<id>"
  if (error) return <ErrorState error={error} />;
  if (!data) return <PageSkeleton />;
  const refresh = () => { void qc.invalidateQueries({ predicate: (q) => String(q.queryKey[0]).startsWith("seller") }); };
  const categories = cats.data?.categories ?? [];
  return (
    <>
      <PageHeader title="Products & stock" description="Stock is taken at checkout (never below 0) and returned when an unpaid order is cancelled."
        actions={<button type="button" className={cx(btn, "bg-primary text-primary-foreground")} onClick={() => setOpen(open === "new" ? null : "new")}><Plus className="size-4" aria-hidden />New product</button>} />
      {open === "new" && <Card className="mb-4"><CardHeader title="New product" /><ProductForm categories={categories} onDone={() => { setOpen(null); refresh(); }} /></Card>}
      <Card>
        <ul className="divide-y">
          {data.map((p) => (
            <li key={p.product_id}>
              <div className="flex flex-wrap items-center gap-3 px-4 py-3">
                <div className="min-w-0 flex-1">
                  <Link to={`/products/${p.product_id}`} className="text-sm font-medium hover:text-accent">{p.name}</Link>
                  <div className="text-xs text-muted-foreground">{p.category ?? "No category"} · {baht(p.price)} · sold {num(p.sold)} · {baht(p.revenue)}</div>
                </div>
                {!p.is_active && <Badge>Hidden</Badge>}
                <Badge tone={p.stock_qty === 0 ? "danger" : p.low ? "warning" : "success"}>{num(p.stock_qty)} in stock</Badge>
                <button type="button" className={cx(btn, "border")} onClick={() => setOpen(open === `stock:${p.product_id}` ? null : `stock:${p.product_id}`)}>Stock</button>
                <button type="button" className={cx(btn, "border")} onClick={() => setOpen(open === `edit:${p.product_id}` ? null : `edit:${p.product_id}`)}>Edit</button>
              </div>
              {open === `edit:${p.product_id}` && <ProductForm p={p} categories={categories} onDone={() => { setOpen(null); refresh(); }} />}
              {open === `stock:${p.product_id}` && <StockPanel p={p} onDone={refresh} />}
            </li>
          ))}
        </ul>
        {data.length === 0 && <p className="p-4 text-sm text-muted-foreground">No products yet.</p>}
      </Card>
    </>
  );
}

// ---------------------------------------------------------------- orders
export function SellerOrdersPage() {
  const [f, set] = useUrlState({ status: "" });
  const { data, error, isLoading } = useApi<Parameters<typeof OrdersTable>[0]["rows"]>("seller/orders", { status: f.status });
  if (error) return <ErrorState error={error} />;
  return (
    <>
      <PageHeader title="Orders" description="Open an order to check the slip, ship it with a tracking number, or decide a refund." />
      <Tabs value={f.status} onChange={(status) => set({ status })} tabs={[{ value: "", label: "All" }, ...STATUSES.map((s) => ({ value: s, label: statusLabel(s) }))]} />
      <Card><OrdersTable rows={data} loading={isLoading} /></Card>
    </>
  );
}

// ---------------------------------------------------------------- promotions (shop coupons)
interface Coupon { coupon_id: number; code: string; discount_type: string; discount_value: number; max_discount: number | null; min_order_amount: number;
  usage_limit_total: number | null; usage_limit_per_user: number; starts_at: string; expires_at: string; is_active: boolean; used: number; discount_given: number }

export function CouponForm({ path, onDone, campaignId }: { path: string; onDone: () => void; campaignId?: number }) {
  const [err, setErr] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  async function submit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const f = new FormData(e.currentTarget);
    const body = { code: String(f.get("code")).toUpperCase(), discount_type: f.get("discount_type"), discount_value: f.get("discount_value"),
      max_discount: f.get("max_discount") || null, min_order_amount: f.get("min_order_amount") || "0",
      usage_limit_total: f.get("usage_limit_total") ? Number(f.get("usage_limit_total")) : null, usage_limit_per_user: Number(f.get("usage_limit_per_user") || 1),
      expires_at: new Date(String(f.get("expires_at"))).toISOString(), campaign_id: campaignId ?? null };
    setBusy(true); setErr(null);
    try { await apiSend("POST", path, body); (e.target as HTMLFormElement).reset(); onDone(); } catch (x) { setErr(errorText(x)); } finally { setBusy(false); }
  }
  return (
    <form onSubmit={submit} className="grid gap-3 p-4 sm:grid-cols-3">
      <label className={label}>Code<input name="code" required pattern="[A-Za-z0-9]{3,20}" className={input} /></label>
      <label className={label}>Type<select name="discount_type" className={input}><option value="PERCENT">Percent</option><option value="FIXED">Fixed THB</option></select></label>
      <label className={label}>Value<input name="discount_value" type="number" step="0.01" min="0.01" required className={input} /></label>
      <label className={label}>Max discount (THB)<input name="max_discount" type="number" step="0.01" min="0.01" className={input} /></label>
      <label className={label}>Minimum spend (THB)<input name="min_order_amount" type="number" step="0.01" min="0" defaultValue="0" className={input} /></label>
      <label className={label}>Expires<input name="expires_at" type="datetime-local" required className={input} /></label>
      <label className={label}>Total uses (blank = no limit)<input name="usage_limit_total" type="number" min="1" className={input} /></label>
      <label className={label}>Uses per buyer<input name="usage_limit_per_user" type="number" min="1" defaultValue="1" className={input} /></label>
      <div className="flex items-end"><button disabled={busy} className={cx(btn, "w-full bg-primary text-primary-foreground")}>{busy && <Loader2 className="size-4 animate-spin" aria-hidden />}Create coupon</button></div>
      {err && <p role="alert" className="text-sm text-destructive sm:col-span-3">{err}</p>}
    </form>
  );
}

export function CouponTable({ rows, path, onDone }: { rows?: Coupon[]; path: string; onDone: () => void }) {
  return (
    <DataTable caption="Coupons" rows={rows} rowKey={(c) => c.coupon_id}
      columns={[
        { key: "code", header: "Code", render: (c) => <span className="font-mono">{c.code}</span> },
        { key: "offer", header: "Offer", render: (c) => couponText(c) },
        { key: "expires_at", header: "Expires", render: (c) => <span className={new Date(c.expires_at) < new Date() ? "text-muted-foreground line-through" : ""}>{when(c.expires_at)}</span> },
        { key: "used", header: "Used", align: "right", render: (c) => `${num(c.used)}${c.usage_limit_total ? ` / ${num(c.usage_limit_total)}` : ""}` },
        { key: "discount_given", header: "Discount given", align: "right", render: (c) => baht(c.discount_given) },
        { key: "is_active", header: "", render: (c) => (
          <button type="button" className={cx(btn, "h-7 border text-xs")} onClick={() => void apiSend("PUT", `${path}/${c.coupon_id}/active`, { active: !c.is_active }).then(onDone)}>{c.is_active ? "Turn off" : "Turn on"}</button>
        ) },
      ]} />
  );
}

export function SellerPromotionsPage() {
  const { data, error, refetch } = useApi<Coupon[]>("seller/coupons");
  if (error) return <ErrorState error={error} />;
  return (
    <>
      <PageHeader title="Promotions" description="Shop coupons: percent or fixed, minimum spend, expiry and usage limits. Checked by the server at checkout; the discount is paid by your shop." />
      <Card className="mb-4"><CardHeader title="New coupon" /><CouponForm path="seller/coupons" onDone={() => void refetch()} /></Card>
      <Card><CouponTable rows={data} path="seller/coupons" onDone={() => void refetch()} /></Card>
    </>
  );
}

// ---------------------------------------------------------------- accounting
interface Ledger { platform_fee_pct: number;
  totals: { orders: number; gross_sales: number; shop_discounts: number; platform_discounts: number; shipping: number; platform_fees: number; refunds: number; net_payout: number };
  monthly: { month: string; orders: number; gross_sales: number; shop_discounts: number; platform_fees: number; refunds: number; net_payout: number }[];
  orders: { order_id: number; order_number: string; paid_on: string; status: string; subtotal: number; shop_discount: number; platform_discount: number; shipping_fee: number; platform_fee: number; refunded: number; net_payout: number }[] }

export function SellerAccountingPage() {
  const [f, set] = useUrlState({ tab: "summary" });
  const { data, error } = useApi<Ledger>("seller/ledger");
  if (error) return <ErrorState error={error} />;
  if (!data) return <PageSkeleton />;
  const t = data.totals;
  return (
    <>
      <PageHeader title="Accounting" description={`Paid orders only. Net payout = sales − shop discounts + shipping − platform fee (${data.platform_fee_pct}%) − refunds. Platform-campaign discounts are paid by the platform.`} />
      <div className="mb-4 grid grid-cols-2 gap-3 lg:grid-cols-4">
        <Kpi label="Gross sales" value={baht(t.gross_sales)} sub={`${num(t.orders)} paid orders`} />
        <Kpi label="Shop discounts" value={baht(t.shop_discounts)} sub={`Platform paid ${baht(t.platform_discounts)}`} />
        <Kpi label="Platform fees + refunds" value={baht(t.platform_fees + t.refunds)} sub={`Fees ${baht(t.platform_fees)} · refunds ${baht(t.refunds)}`} />
        <Kpi label="Net payout" value={baht(t.net_payout)} tone={t.net_payout >= 0 ? "success" : "danger"} sub={`incl. shipping ${baht(t.shipping)}`} />
      </div>
      <Tabs value={f.tab} onChange={(tab) => set({ tab })} tabs={[{ value: "summary", label: "By month" }, { value: "orders", label: "By order" }]} />
      <Card>
        {f.tab === "orders" ? (
          <DataTable caption="Ledger by order" rows={data.orders} rowKey={(r) => r.order_id} dense rowHref={(r) => `/orders/${r.order_id}`}
            columns={[{ key: "order_number", header: "Order", render: (r) => <span className="font-mono text-xs">{r.order_number}</span> }, { key: "paid_on", header: "Paid" },
              { key: "status", header: "Status", render: (r) => statusLabel(r.status) }, { key: "subtotal", header: "Sales", align: "right", render: (r) => baht(r.subtotal) },
              { key: "shop_discount", header: "Shop disc.", align: "right", render: (r) => baht(r.shop_discount) }, { key: "platform_fee", header: "Fee", align: "right", render: (r) => baht(r.platform_fee) },
              { key: "refunded", header: "Refund", align: "right", render: (r) => (r.refunded ? baht(r.refunded) : "—") }, { key: "net_payout", header: "Net", align: "right", render: (r) => <b>{baht(r.net_payout)}</b> }]} />
        ) : (
          <DataTable caption="Ledger by month" rows={data.monthly} rowKey={(r) => r.month}
            columns={[{ key: "month", header: "Month" }, { key: "orders", header: "Orders", align: "right" }, { key: "gross_sales", header: "Sales", align: "right", render: (r) => baht(r.gross_sales) },
              { key: "shop_discounts", header: "Shop disc.", align: "right", render: (r) => baht(r.shop_discounts) }, { key: "platform_fees", header: "Fees", align: "right", render: (r) => baht(r.platform_fees) },
              { key: "refunds", header: "Refunds", align: "right", render: (r) => baht(r.refunds) }, { key: "net_payout", header: "Net payout", align: "right", render: (r) => <b>{baht(r.net_payout)}</b> }]} />
        )}
      </Card>
    </>
  );
}

// ---------------------------------------------------------------- customers
interface Customer { buyer: string; orders: number; spend: number; last_order: string; segment: string; products: string }

export function SellerCustomersPage() {
  const { data, error } = useApi<Customer[]>("seller/customers");
  if (error) return <ErrorState error={error} />;
  if (!data) return <PageSkeleton />;
  const seg = (s: string) => data.filter((c) => c.segment === s).length;
  return (
    <>
      <PageHeader title="Customers" description="Buyers with paid orders. Frequent = 3+ orders, Repeat = 2, New = 1." />
      <Card className="mb-4"><DefinitionList items={[["Frequent buyers", num(seg("Frequent"))], ["Repeat buyers", num(seg("Repeat"))], ["New buyers", num(seg("New"))]]} /></Card>
      <Card>
        <DataTable caption="Customers" rows={data} rowKey={(c) => c.buyer}
          columns={[{ key: "buyer", header: "Buyer" }, { key: "segment", header: "Group", render: (c) => <Badge tone={c.segment === "Frequent" ? "success" : c.segment === "Repeat" ? "info" : "neutral"}>{c.segment}</Badge> },
            { key: "orders", header: "Orders", align: "right" }, { key: "spend", header: "Spend", align: "right", render: (c) => baht(c.spend) },
            { key: "last_order", header: "Last order", render: (c) => when(c.last_order) }, { key: "products", header: "Bought", className: "max-w-64 truncate" }]} />
      </Card>
    </>
  );
}
