import { useQueryClient } from "@tanstack/react-query";
import { CheckCircle2, Circle, ExternalLink, Loader2, XCircle } from "lucide-react";
import { useState, type ReactNode } from "react";
import { Link, useParams } from "react-router";
import { DataTable } from "../components/DataTable";
import { Badge, Card, CardHeader, cx, DefinitionList, ErrorState, PageHeader, PageSkeleton, Tabs } from "../components/ui";
import { ApiError, apiSend, errorText, useApi, useUrlState } from "../lib/api";
import { baht } from "../lib/format";
import { supabase } from "../lib/supabase";

export type Tone = "neutral" | "info" | "success" | "warning" | "danger";
export const STATUS_TONE: Record<string, Tone> = { PENDING_PAYMENT: "warning", TO_SHIP: "info", SHIPPED: "info", DELIVERED: "success", CANCELLED: "neutral", REFUNDED: "danger" };
export const statusLabel = (s: string) => ({ PENDING_PAYMENT: "To pay", TO_SHIP: "To ship", SHIPPED: "Shipped", DELIVERED: "Delivered", CANCELLED: "Cancelled", REFUNDED: "Refunded" } as Record<string, string>)[s] ?? s;
export const Status = ({ s }: { s: string }) => <Badge tone={STATUS_TONE[s] ?? "neutral"}>{statusLabel(s)}</Badge>;
export const when = (s: string) => new Date(s).toLocaleString("en-GB", { dateStyle: "medium", timeStyle: "short", timeZone: "Asia/Bangkok" });
const input = "h-9 w-full rounded-md border bg-card px-2.5 text-sm focus-visible:outline-2 focus-visible:outline-ring";
const btn = "inline-flex h-9 items-center justify-center gap-1.5 rounded-md px-3 text-sm font-medium disabled:opacity-50";
export const STATUSES = ["PENDING_PAYMENT", "TO_SHIP", "SHIPPED", "DELIVERED", "CANCELLED", "REFUNDED"];

interface OrderRow { order_id: number; order_number: string; status: string; total: number; created_at: string; shop?: string; buyer?: string; items: number;
  tracking_number?: string | null; slip_pending?: boolean; refund_requested?: boolean }

export function OrdersTable({ rows, loading }: { rows?: OrderRow[]; loading?: boolean }) {
  return (
    <DataTable caption="Orders" rows={rows} loading={loading} rowKey={(r) => r.order_id} rowHref={(r) => `/orders/${r.order_id}`}
      columns={[
        { key: "order_number", header: "Order", render: (r) => <span className="font-mono text-xs">{r.order_number}</span> },
        { key: "created_at", header: "Placed", render: (r) => <span className="whitespace-nowrap">{when(r.created_at)}</span> },
        { key: "party", header: rows?.[0]?.buyer !== undefined ? "Buyer" : "Shop", render: (r) => r.buyer ?? r.shop },
        { key: "items", header: "Items", align: "right" },
        { key: "total", header: "Total", align: "right", render: (r) => baht(r.total) },
        { key: "status", header: "Status", render: (r) => (
          <div className="flex flex-wrap gap-1"><Status s={r.status} />{r.slip_pending && <Badge tone="warning">Slip to check</Badge>}{r.refund_requested && <Badge tone="danger">Refund asked</Badge>}</div>
        ) },
      ]} />
  );
}

export function MyOrdersPage() {
  const [f, set] = useUrlState({ status: "" });
  const { data, error, isLoading } = useApi<OrderRow[]>("my/orders", { status: f.status });
  if (error) return <ErrorState error={error} />;
  return (
    <>
      <PageHeader title="My orders" />
      <Tabs value={f.status} onChange={(status) => set({ status })} tabs={[{ value: "", label: "All" }, ...STATUSES.map((s) => ({ value: s, label: statusLabel(s) }))]} />
      <Card><OrdersTable rows={data} loading={isLoading} /></Card>
    </>
  );
}

// ---------------------------------------------------------------- one order (buyer, seller or admin)
interface Order {
  order_id: number; order_number: string; status: string; subtotal: number; discount: number; shipping_fee: number; total: number; coupon_code: string | null;
  platform_funded: boolean; ship_name: string; ship_phone: string; ship_address: string; created_at: string; pay_by: string; carrier: string | null;
  tracking_number: string | null; viewer: "buyer" | "seller" | "admin"; buyer_id: string; shop: { shop_id: number; name: string }; buyer: { display_name: string };
  items: { line_no: number; product_id: number; name: string; unit_price: number; qty: number; line_total: number }[];
  events: { status: string; note: string | null; at: string }[];
  slips: { slip_id: number; trans_ref: string; amount: number; slip_path: string; status: string; note: string | null; uploaded_at: string }[];
  refunds: { refund_id: number; reason: string; amount: number; status: string; note: string | null; created_at: string }[];
}

function Box({ title, children }: { title: string; children: ReactNode }) {
  return <Card><CardHeader title={title} /><div className="space-y-2 p-4">{children}</div></Card>;
}

function SlipLink({ path }: { path: string }) {
  const [err, setErr] = useState<string | null>(null);
  async function open() {
    const { data, error } = await supabase.storage.from("payment-slips").createSignedUrl(path, 120);
    if (error || !data) { setErr("Cannot open the slip"); return; }
    window.open(data.signedUrl, "_blank", "noopener");
  }
  return <><button type="button" onClick={open} className="inline-flex items-center gap-1 text-xs text-accent underline">View slip<ExternalLink className="size-3" aria-hidden /></button>{err && <span className="text-xs text-destructive"> {err}</span>}</>;
}

export function OrderPage() {
  const { id } = useParams();
  const qc = useQueryClient();
  const { data: o, error } = useApi<Order>(`orders/${id}`);
  const [busy, setBusy] = useState(false);
  const [err, setErr] = useState<string | null>(null);
  const [form, setForm] = useState({ trans_ref: "", carrier: "Kerry Express", tracking_number: "", reason: "", note: "" });
  const [file, setFile] = useState<File | null>(null);
  if (error) return <ErrorState error={error instanceof ApiError && error.status === 404 ? new Error("This order does not exist or is not yours.") : error} />;
  if (!o) return <PageSkeleton />;
  const order = o;

  async function act(fn: () => Promise<unknown>) {
    setBusy(true); setErr(null);
    try { await fn(); await qc.invalidateQueries(); } catch (e) { setErr(errorText(e)); } finally { setBusy(false); }
  }
  const uploadSlip = () => act(async () => {
    if (!file) throw new Error("Choose the slip image first");
    const { data: s } = await supabase.auth.getSession();
    const path = `${s.session?.user.id}/${order.order_id}/${Date.now()}-${file.name.replace(/[^A-Za-z0-9._-]/g, "_")}`;
    const up = await supabase.storage.from("payment-slips").upload(path, file, { contentType: file.type });
    if (up.error) throw new Error(up.error.message);
    await apiSend("POST", `orders/${order.order_id}/slip`, { trans_ref: form.trans_ref, amount: order.total.toFixed(2), slip_path: path });
  });
  const pendingSlip = o.slips.find((s) => s.status === "PENDING");
  const openRefund = o.refunds.find((r) => r.status === "REQUESTED");
  const done = new Set(o.events.map((e) => e.status));
  const steps = ["PENDING_PAYMENT", "TO_SHIP", "SHIPPED", "DELIVERED"];

  return (
    <>
      <PageHeader title={<span className="font-mono">{o.order_number}</span>} badge={<Status s={o.status} />}
        back={{ to: o.viewer === "seller" ? "/seller/orders" : o.viewer === "admin" ? "/admin" : "/orders", label: "Orders" }}
        description={<>{o.viewer === "buyer" ? <Link to={`/shops/${o.shop.shop_id}`} className="hover:text-accent">{o.shop.name}</Link> : `Buyer: ${o.buyer.display_name}`} · placed {when(o.created_at)}</>} />
      <ol className="mb-5 grid grid-cols-4 gap-2" aria-label="Order progress">
        {steps.map((s) => (
          <li key={s} className={cx("flex items-center gap-1.5 rounded-md border px-2 py-2 text-xs sm:text-sm", done.has(s) ? "border-success/50 text-success" : "text-muted-foreground")}>
            {done.has(s) ? <CheckCircle2 className="size-4 shrink-0" aria-hidden /> : <Circle className="size-4 shrink-0" aria-hidden />}{statusLabel(s)}
          </li>
        ))}
      </ol>
      {(o.status === "CANCELLED" || o.status === "REFUNDED") && <p className="mb-4 flex items-center gap-2 text-sm text-muted-foreground"><XCircle className="size-4" aria-hidden />This order was {statusLabel(o.status).toLowerCase()}.</p>}
      {err && <p role="alert" className="mb-4 rounded-md border border-destructive/40 bg-destructive/10 px-3 py-2 text-sm text-destructive">{err}</p>}
      <div className="grid gap-4 lg:grid-cols-[1fr_minmax(0,22rem)]">
        <div className="min-w-0 space-y-4">
          <Card>
            <CardHeader title="Items" />
            <DataTable caption="Items" rows={o.items} rowKey={(i) => i.line_no} dense rowHref={(i) => `/products/${i.product_id}`}
              columns={[{ key: "name", header: "Product" }, { key: "qty", header: "Qty", align: "right" },
                { key: "unit_price", header: "Price", align: "right", render: (i) => baht(i.unit_price) }, { key: "line_total", header: "Amount", align: "right", render: (i) => baht(i.line_total) }]} />
            <DefinitionList items={[["Subtotal", baht(o.subtotal)], ["Discount" + (o.coupon_code ? ` (${o.coupon_code}${o.platform_funded ? ", platform" : ""})` : ""), o.discount ? `−${baht(o.discount)}` : "—"],
              ["Shipping", o.shipping_fee ? baht(o.shipping_fee) : "Free"], ["Total", <b>{baht(o.total)}</b>]]} />
          </Card>
          <Card>
            <CardHeader title="Tracking" description={o.tracking_number ? `${o.carrier} · ${o.tracking_number}` : "No tracking number yet"} />
            <ol className="space-y-3 p-4">
              {o.events.map((e, i) => (
                <li key={i} className="relative border-l-2 border-primary/40 pl-4">
                  <div className="text-sm font-medium">{statusLabel(e.status)}</div>
                  <div className="text-xs text-muted-foreground">{when(e.at)}</div>
                  {e.note && <div className="text-sm">{e.note}</div>}
                </li>
              ))}
            </ol>
          </Card>
        </div>
        <div className="space-y-4">
          <Box title="Deliver to"><p className="text-sm">{o.ship_name} · {o.ship_phone}<br />{o.ship_address}</p></Box>
          {o.slips.length > 0 && (
            <Box title="Payment slips">
              {o.slips.map((s) => (
                <div key={s.slip_id} className="text-sm"><span className="font-mono text-xs">{s.trans_ref}</span> · {baht(s.amount)} <Badge tone={s.status === "APPROVED" ? "success" : s.status === "REJECTED" ? "danger" : "warning"}>{s.status}</Badge>
                  <div><SlipLink path={s.slip_path} />{s.note && <span className="ml-2 text-xs text-muted-foreground">{s.note}</span>}</div></div>
              ))}
            </Box>
          )}
          {o.viewer === "buyer" && o.status === "PENDING_PAYMENT" && !pendingSlip && (
            <Box title="Pay by bank transfer">
              <p className="text-xs text-muted-foreground">Transfer {baht(o.total)} by {when(o.pay_by)}, then upload the slip. Each transfer reference can be used once.</p>
              <input type="file" accept="image/png,image/jpeg,image/webp,application/pdf" aria-label="Slip image" onChange={(e) => setFile(e.target.files?.[0] ?? null)} className="text-sm" />
              <input aria-label="Transfer reference" placeholder="Transfer reference (on the slip)" className={input} value={form.trans_ref} onChange={(e) => setForm({ ...form, trans_ref: e.target.value })} />
              <button type="button" disabled={busy} onClick={uploadSlip} className={cx(btn, "w-full bg-primary text-primary-foreground")}>{busy && <Loader2 className="size-4 animate-spin" aria-hidden />}Send slip</button>
            </Box>
          )}
          {o.viewer === "seller" && pendingSlip && (
            <Box title="Check the payment slip">
              <p className="text-sm">Order total {baht(o.total)}; slip says {baht(pendingSlip.amount)} (ref <span className="font-mono">{pendingSlip.trans_ref}</span>).</p>
              <SlipLink path={pendingSlip.slip_path} />
              <input aria-label="Note" placeholder="Note (required to reject)" className={input} value={form.note} onChange={(e) => setForm({ ...form, note: e.target.value })} />
              <div className="flex gap-2">
                <button type="button" disabled={busy} className={cx(btn, "flex-1 bg-success text-white")} onClick={() => act(() => apiSend("POST", `seller/slips/${pendingSlip.slip_id}/review`, { approve: true, note: form.note || null }))}>Approve payment</button>
                <button type="button" disabled={busy || !form.note} className={cx(btn, "flex-1 border")} onClick={() => act(() => apiSend("POST", `seller/slips/${pendingSlip.slip_id}/review`, { approve: false, note: form.note }))}>Reject</button>
              </div>
            </Box>
          )}
          {o.viewer === "seller" && o.status === "TO_SHIP" && !openRefund && (
            <Box title="Ship the order">
              <input aria-label="Carrier" className={input} value={form.carrier} onChange={(e) => setForm({ ...form, carrier: e.target.value })} />
              <input aria-label="Tracking number" placeholder="Tracking number" className={input} value={form.tracking_number} onChange={(e) => setForm({ ...form, tracking_number: e.target.value })} />
              <button type="button" disabled={busy} className={cx(btn, "w-full bg-primary text-primary-foreground")} onClick={() => act(() => apiSend("POST", `seller/orders/${o.order_id}/ship`, { carrier: form.carrier, tracking_number: form.tracking_number }))}>Mark as shipped</button>
            </Box>
          )}
          {(o.viewer === "buyer" || o.viewer === "seller") && o.status === "SHIPPED" && (
            <Box title="Delivery"><button type="button" disabled={busy} className={cx(btn, "w-full bg-primary text-primary-foreground")} onClick={() => act(() => apiSend("POST", `orders/${o.order_id}/received`))}>{o.viewer === "buyer" ? "I received the order" : "Mark as delivered"}</button></Box>
          )}
          {o.viewer === "seller" && openRefund && (
            <Box title="Refund request">
              <p className="text-sm">"{openRefund.reason}" · {baht(openRefund.amount)}</p>
              <input aria-label="Note" placeholder="Note to the buyer" className={input} value={form.note} onChange={(e) => setForm({ ...form, note: e.target.value })} />
              <div className="flex gap-2">
                <button type="button" disabled={busy} className={cx(btn, "flex-1 bg-destructive text-white")} onClick={() => act(() => apiSend("POST", `seller/refunds/${openRefund.refund_id}/decision`, { approve: true, note: form.note || null }))}>Approve refund</button>
                <button type="button" disabled={busy} className={cx(btn, "flex-1 border")} onClick={() => act(() => apiSend("POST", `seller/refunds/${openRefund.refund_id}/decision`, { approve: false, note: form.note || null }))}>Reject</button>
              </div>
            </Box>
          )}
          {o.viewer === "buyer" && ["TO_SHIP", "SHIPPED", "DELIVERED"].includes(o.status) && !openRefund && (
            <Box title="Request a refund">
              <textarea aria-label="Reason" rows={2} placeholder="What went wrong?" className={input + " h-auto py-2"} value={form.reason} onChange={(e) => setForm({ ...form, reason: e.target.value })} />
              <button type="button" disabled={busy || form.reason.trim().length < 3} className={cx(btn, "w-full border")} onClick={() => act(() => apiSend("POST", `orders/${o.order_id}/refund`, { reason: form.reason }))}>Send refund request</button>
            </Box>
          )}
          {o.refunds.length > 0 && <Box title="Refunds">{o.refunds.map((r) => <div key={r.refund_id} className="text-sm">{r.reason} · <Badge tone={r.status === "APPROVED" ? "success" : r.status === "REJECTED" ? "neutral" : "warning"}>{r.status}</Badge>{r.note && <div className="text-xs text-muted-foreground">{r.note}</div>}</div>)}</Box>}
          {(o.viewer === "buyer" || o.viewer === "seller") && o.status === "PENDING_PAYMENT" && (
            <button type="button" disabled={busy} className={cx(btn, "w-full border text-destructive")} onClick={() => act(() => apiSend("POST", `orders/${o.order_id}/cancel`, { reason: o.viewer === "buyer" ? "Cancelled by the buyer" : "Cancelled by the seller" }))}>Cancel order</button>
          )}
        </div>
      </div>
    </>
  );
}
