import { Loader2 } from "lucide-react";
import { useState, type FormEvent } from "react";
import { DataTable } from "../components/DataTable";
import { Badge, Card, CardHeader, cx, ErrorState, Kpi, PageHeader, PageSkeleton, SearchInput } from "../components/ui";
import { apiSend, errorText, useApi, useUrlState } from "../lib/api";
import { baht, num } from "../lib/format";
import type { CatalogItem } from "./Catalog";
import { when } from "./Orders";
import { CouponForm } from "./Seller";

const input = "h-9 w-full rounded-md border bg-card px-2.5 text-sm focus-visible:outline-2 focus-visible:outline-ring";
const btn = "inline-flex h-9 items-center justify-center gap-1.5 rounded-md px-3 text-sm font-medium disabled:opacity-50";
const label = "block text-xs font-medium text-muted-foreground";

interface Overview { users: Record<string, number>; banned: number; gmv: number; platform_fees: number;
  top_shops: { shop_id: number; name: string; owner_status: string; orders: number; sales: number; buyers: number }[] }

export function AdminHomePage() {
  const [f, set] = useUrlState({ days: "30" });
  const { data, error } = useApi<Overview>("admin/overview", { days: f.days });
  if (error) return <ErrorState error={error} />;
  if (!data) return <PageSkeleton />;
  return (
    <>
      <PageHeader title="Platform" description="Which shops sell well, users and platform income." actions={
        <select aria-label="Period" value={f.days} onChange={(e) => set({ days: e.target.value })} className={input + " w-36"}>
          {["7", "30", "90", "365"].map((d) => <option key={d} value={d}>Last {d} days</option>)}</select>} />
      <div className="mb-4 grid grid-cols-2 gap-3 lg:grid-cols-4">
        <Kpi label="GMV (paid orders)" value={baht(data.gmv)} />
        <Kpi label="Platform fees (5%)" value={baht(data.platform_fees)} />
        <Kpi label="Buyers / sellers" value={`${num(data.users.buyer ?? 0)} / ${num(data.users.seller ?? 0)}`} to="/admin/users" />
        <Kpi label="Banned users" value={num(data.banned)} to="/admin/users" tone={data.banned ? "warning" : undefined} />
      </div>
      <Card>
        <CardHeader title="Top shops" description="Ranked by paid sales in the period" />
        <DataTable caption="Top shops" rows={data.top_shops} rowKey={(s) => s.shop_id} rowHref={(s) => `/shops/${s.shop_id}`}
          columns={[{ key: "rank", header: "#", render: (s) => data.top_shops.indexOf(s) + 1 }, { key: "name", header: "Shop", render: (s) => <>{s.name} {s.owner_status === "banned" && <Badge tone="danger">Banned</Badge>}</> },
            { key: "orders", header: "Orders", align: "right" }, { key: "buyers", header: "Buyers", align: "right" }, { key: "sales", header: "Sales", align: "right", render: (s) => <b>{baht(s.sales)}</b> }]} />
      </Card>
    </>
  );
}

interface AdminUser { user_id: string; email: string; display_name: string; role: string; status: string; ban_reason: string | null; created_at: string; shop: string | null; orders: number }

export function AdminUsersPage() {
  const [f, set] = useUrlState({ q: "" });
  const { data, error, refetch } = useApi<AdminUser[]>("admin/users", { q: f.q });
  const [err, setErr] = useState<string | null>(null);
  const [reason, setReason] = useState("");
  if (error) return <ErrorState error={error} />;
  async function toggle(u: AdminUser) {
    setErr(null);
    const banned = u.status !== "banned";
    try { await apiSend("POST", `admin/users/${u.user_id}/ban`, { banned, reason: banned ? reason : null }); setReason(""); await refetch(); } catch (x) { setErr(errorText(x)); }
  }
  return (
    <>
      <PageHeader title="Users" description="A ban stops sign-in and every action at once (the database checks it on each call); a banned seller's products disappear from the shop." />
      <div className="mb-3 flex flex-wrap items-end gap-3">
        <div className="max-w-md flex-1"><SearchInput value={f.q} onChange={(q) => set({ q })} placeholder="Email or name" /></div>
        <label className={cx(label, "min-w-56 flex-1")}>Ban reason (needed to ban)<input value={reason} onChange={(e) => setReason(e.target.value)} className={input} /></label>
      </div>
      {err && <p role="alert" className="mb-3 text-sm text-destructive">{err}</p>}
      <Card>
        <DataTable caption="Users" rows={data} rowKey={(u) => u.user_id}
          columns={[{ key: "display_name", header: "User", render: (u) => <div><div>{u.display_name}</div><div className="text-xs text-muted-foreground">{u.email}</div></div> },
            { key: "role", header: "Role", render: (u) => <Badge tone={u.role === "admin" ? "info" : "neutral"}>{u.role}</Badge> }, { key: "shop", header: "Shop", render: (u) => u.shop ?? "" },
            { key: "orders", header: "Orders", align: "right" }, { key: "created_at", header: "Joined", render: (u) => when(u.created_at) },
            { key: "status", header: "Status", render: (u) => u.status === "banned" ? <span><Badge tone="danger">Banned</Badge> <span className="text-xs text-muted-foreground">{u.ban_reason}</span></span> : <Badge tone="success">Active</Badge> },
            { key: "act", header: "", render: (u) => u.role === "admin" ? null : <button type="button" disabled={u.status !== "banned" && !reason.trim()} title={u.status !== "banned" && !reason.trim() ? "Type a ban reason first" : undefined} className={cx(btn, "h-7 border text-xs", u.status !== "banned" && "text-destructive")} onClick={() => void toggle(u)}>{u.status === "banned" ? "Unban" : "Ban"}</button> }]} />
      </Card>
    </>
  );
}

interface Campaign { campaign_id: number; name: string; description: string | null; starts_at: string; ends_at: string; products: number;
  coupons: { coupon_id: number; code: string; is_active: boolean; used: number; discount_given: number }[] }

export function AdminCampaignsPage() {
  const { data, error, refetch } = useApi<Campaign[]>("admin/campaigns");
  const products = useApi<{ items: CatalogItem[] }>("catalog", { page_size: 100, sort: "popular" });
  const [picked, setPicked] = useState<number[]>([]);
  const [busy, setBusy] = useState(false);
  const [err, setErr] = useState<string | null>(null);
  const [couponFor, setCouponFor] = useState<number | null>(null);
  if (error) return <ErrorState error={error} />;
  async function create(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const f = new FormData(e.currentTarget);
    setBusy(true); setErr(null);
    try {
      await apiSend("POST", "admin/campaigns", { name: f.get("name"), description: f.get("description") || null, starts_at: new Date(String(f.get("starts_at"))).toISOString(),
        ends_at: new Date(String(f.get("ends_at"))).toISOString(), product_ids: picked });
      (e.target as HTMLFormElement).reset(); setPicked([]); await refetch();
    } catch (x) { setErr(errorText(x)); } finally { setBusy(false); }
  }
  return (
    <>
      <PageHeader title="Campaigns" description="Platform campaigns: a banner on the home page, featured products and platform coupons (usable in every shop, paid by the platform)." />
      <Card className="mb-4">
        <CardHeader title="New campaign" />
        <form onSubmit={create} className="grid gap-3 p-4 sm:grid-cols-2">
          <label className={label}>Name<input name="name" required minLength={3} className={input} /></label>
          <label className={label}>Description<input name="description" className={input} /></label>
          <label className={label}>Starts<input name="starts_at" type="datetime-local" required className={input} /></label>
          <label className={label}>Ends<input name="ends_at" type="datetime-local" required className={input} /></label>
          <fieldset className="sm:col-span-2"><legend className={label}>Featured products ({picked.length})</legend>
            <div className="mt-1 grid max-h-48 gap-1 overflow-y-auto rounded-md border p-2 sm:grid-cols-2">
              {(products.data?.items ?? []).map((p) => (
                <label key={p.product_id} className="flex items-center gap-2 text-sm"><input type="checkbox" checked={picked.includes(p.product_id)}
                  onChange={(e) => setPicked(e.target.checked ? [...picked, p.product_id] : picked.filter((x) => x !== p.product_id))} />{p.name} <span className="text-xs text-muted-foreground">· {p.shop}</span></label>
              ))}
            </div>
          </fieldset>
          {err && <p role="alert" className="text-sm text-destructive sm:col-span-2">{err}</p>}
          <div><button disabled={busy} className={cx(btn, "bg-primary text-primary-foreground")}>{busy && <Loader2 className="size-4 animate-spin" aria-hidden />}Create campaign</button></div>
        </form>
      </Card>
      {!data ? <PageSkeleton /> : data.map((c) => (
        <Card key={c.campaign_id} className="mb-3">
          <CardHeader title={c.name} description={`${when(c.starts_at)} – ${when(c.ends_at)} · ${num(c.products)} featured products${c.description ? ` · ${c.description}` : ""}`}
            actions={<button type="button" className={cx(btn, "h-8 border text-xs")} onClick={() => setCouponFor(couponFor === c.campaign_id ? null : c.campaign_id)}>Add platform coupon</button>} />
          <div className="flex flex-wrap gap-2 p-4">
            {c.coupons.length === 0 && <span className="text-sm text-muted-foreground">No coupon yet.</span>}
            {c.coupons.map((k) => (
              <span key={k.coupon_id} className="inline-flex items-center gap-2 rounded-md border px-2 py-1 text-xs"><b className="font-mono">{k.code}</b> used {num(k.used)} · {baht(k.discount_given)}
                <button type="button" className="text-accent underline" onClick={() => void apiSend("PUT", `admin/coupons/${k.coupon_id}/active`, { active: !k.is_active }).then(() => refetch())}>{k.is_active ? "turn off" : "turn on"}</button></span>
            ))}
          </div>
          {couponFor === c.campaign_id && <CouponForm path="admin/coupons" campaignId={c.campaign_id} onDone={() => { setCouponFor(null); void refetch(); }} />}
        </Card>
      ))}
    </>
  );
}
