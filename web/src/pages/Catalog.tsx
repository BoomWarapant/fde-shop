import { ImageOff, Megaphone, Tag } from "lucide-react";
import { Link, useParams } from "react-router";
import { Card, ErrorState, PageHeader, Select } from "../components/ui";
import { useApi, useUrlState } from "../lib/api";
import { baht, num } from "../lib/format";

export interface CatalogItem { product_id: number; name: string; price: number; image_url: string | null; stock_qty: number; category: string | null; shop_id: number; shop: string; sold: number }
interface Catalog { total: number; categories: { category_id: number; name: string }[]; items: CatalogItem[]; page: number; page_size: number }
interface Campaign { campaign_id: number; name: string; description: string | null; ends_at: string;
  coupons: { code: string; discount_type: string; discount_value: number; min_order_amount: number; max_discount: number | null }[];
  products: { product_id: number; name: string; price: number; image_url: string | null; shop: string }[] }

export const couponText = (c: { discount_type: string; discount_value: number; min_order_amount: number; max_discount: number | null }) =>
  `${c.discount_type === "PERCENT" ? `${c.discount_value}% off` : `${baht(c.discount_value)} off`}${c.max_discount ? ` (up to ${baht(c.max_discount)})` : ""}${c.min_order_amount > 0 ? ` from ${baht(c.min_order_amount)}` : ""}`;

export function ProductImage({ src, alt, className }: { src: string | null; alt: string; className?: string }) {
  return src ? <img src={src} alt={alt} loading="lazy" className={className ?? "aspect-square w-full rounded-t-lg object-cover"} />
    : <div className={(className ?? "aspect-square w-full rounded-t-lg") + " flex items-center justify-center bg-muted text-muted-foreground"}><ImageOff className="size-6" aria-hidden /></div>;
}

function ProductCard({ p }: { p: CatalogItem }) {
  return (
    <Link to={`/products/${p.product_id}`} className="group flex flex-col rounded-lg border bg-card transition-colors duration-150 hover:border-accent/60">
      <ProductImage src={p.image_url} alt={p.name} />
      <div className="flex flex-1 flex-col gap-1 p-3">
        <div className="line-clamp-2 text-sm font-medium group-hover:text-accent">{p.name}</div>
        <div className="mt-auto text-base font-semibold text-accent">{baht(p.price)}</div>
        <div className="flex justify-between gap-2 text-xs text-muted-foreground"><span className="truncate">{p.shop}</span><span className="shrink-0">{p.stock_qty > 0 ? `${num(p.sold)} sold` : "Sold out"}</span></div>
      </div>
    </Link>
  );
}

export function CatalogPage() {
  const { id: shopId } = useParams();
  const [f, set] = useUrlState({ q: "", category_id: "", sort: "new", page: "1" });
  const { data, error, isFetching } = useApi<Catalog>("catalog", { ...f, shop_id: shopId, page_size: 24 });
  const campaigns = useApi<Campaign[]>(shopId ? null : "campaigns");
  const page = Number(f.page) || 1;
  const pages = data ? Math.max(1, Math.ceil(data.total / data.page_size)) : 1;
  if (error) return <ErrorState error={error} />;
  const shopName = shopId ? data?.items[0]?.shop : undefined;
  return (
    <>
      {!shopId && !f.q && (campaigns.data ?? []).map((c) => (
        <Card key={c.campaign_id} className="mb-5 overflow-hidden border-primary/40">
          <div className="flex flex-wrap items-center gap-3 bg-primary/10 px-4 py-3">
            <Megaphone className="size-5 text-primary" aria-hidden />
            <div className="min-w-0 flex-1"><div className="font-semibold">{c.name}</div><div className="text-sm text-muted-foreground">{c.description}</div></div>
            {c.coupons.map((k) => <span key={k.code} className="inline-flex items-center gap-1 rounded-md border border-dashed border-primary px-2 py-1 text-xs"><Tag className="size-3.5" aria-hidden /><b>{k.code}</b> · {couponText(k)}</span>)}
          </div>
          {c.products.length > 0 && (
            <div className="grid grid-cols-2 gap-3 p-3 sm:grid-cols-4">
              {c.products.map((p) => (
                <Link key={p.product_id} to={`/products/${p.product_id}`} className="flex items-center gap-2 rounded-md p-1 hover:bg-muted">
                  <ProductImage src={p.image_url} alt={p.name} className="size-12 shrink-0 rounded-md object-cover" />
                  <span className="min-w-0 text-xs"><span className="line-clamp-2">{p.name}</span><b className="text-accent">{baht(p.price)}</b></span>
                </Link>
              ))}
            </div>
          )}
        </Card>
      ))}
      <PageHeader title={shopId ? shopName ?? "Shop" : f.q ? `Results for "${f.q}"` : "All products"} description={data ? `${num(data.total)} products` : " "} />
      <div className="mb-4 flex flex-wrap gap-3">
        <Select label="Category" value={f.category_id} onChange={(e) => set({ category_id: e.target.value })}
          options={[{ value: "", label: "All categories" }, ...(data?.categories ?? []).map((c) => ({ value: c.category_id, label: c.name }))]} />
        <Select label="Sort" value={f.sort} onChange={(e) => set({ sort: e.target.value })}
          options={[{ value: "new", label: "Newest" }, { value: "popular", label: "Best selling" }, { value: "price_asc", label: "Price: low to high" }, { value: "price_desc", label: "Price: high to low" }]} />
      </div>
      <div className={"grid grid-cols-2 gap-3 transition-opacity sm:grid-cols-3 lg:grid-cols-4 " + (isFetching ? "opacity-60" : "")}>
        {data?.items.map((p) => <ProductCard key={p.product_id} p={p} />)}
      </div>
      {data && data.total === 0 && <p className="py-10 text-center text-sm text-muted-foreground">No products match.</p>}
      {pages > 1 && (
        <div className="mt-5 flex items-center justify-center gap-3 text-sm">
          <button type="button" className="rounded-md border px-3 py-1.5 disabled:opacity-50" disabled={page <= 1} onClick={() => set({ page: page - 1 })}>Previous</button>
          <span>Page {page} of {pages}</span>
          <button type="button" className="rounded-md border px-3 py-1.5 disabled:opacity-50" disabled={page >= pages} onClick={() => set({ page: page + 1 })}>Next</button>
        </div>
      )}
    </>
  );
}
