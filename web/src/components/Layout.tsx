import { Bot, Loader2, LogOut, Search, ShoppingBag, ShoppingCart, Store, UserRound } from "lucide-react";
import { useEffect, useRef, useState, type ReactNode } from "react";
import { Link, Navigate, NavLink, Outlet, useLocation, useNavigate } from "react-router";
import { api, useApi } from "../lib/api";
import { useAuth, type Role } from "../lib/auth";
import { baht } from "../lib/format";
import { ErrorBoundary } from "./ErrorBoundary";
import { FloatingBot } from "./FloatingBot";
import { cx } from "./ui";

interface CartShop { items: { qty: number }[] }

interface SuggestResponse {
  query: string;
  parsed_hints: string[];
  products: { product_id: number; name: string; brand?: string | null; price: number; unit?: string | null; category_th?: string | null; shop: string }[];
  categories: { category_id: number; name: string; name_th?: string | null; icon?: string | null }[];
  brands: { brand: string; count: number }[];
}

const LINKS: Record<Role, { to: string; label: string; end?: boolean }[]> = {
  buyer: [{ to: "/orders", label: "My orders" }],
  seller: [
    { to: "/seller", label: "Overview", end: true },
    { to: "/seller/products", label: "Products" },
    { to: "/seller/orders", label: "Orders" },
    { to: "/seller/promotions", label: "Promotions" },
    { to: "/seller/accounting", label: "Accounting" },
    { to: "/seller/customers", label: "Customers" },
  ],
  admin: [
    { to: "/admin", label: "Overview", end: true },
    { to: "/admin/users", label: "Users" },
    { to: "/admin/campaigns", label: "Campaigns" },
  ],
};

function CartButton() {
  const { data } = useApi<CartShop[]>("cart");
  const n = (data ?? []).reduce((a, s) => a + s.items.reduce((b, i) => b + i.qty, 0), 0);
  return (
    <Link to="/cart" aria-label={`Cart, ${n} items`} className="relative inline-flex size-10 items-center justify-center rounded-md hover:bg-muted">
      <ShoppingCart className="size-5" aria-hidden />
      {n > 0 && (
        <span className="absolute -top-0.5 -right-0.5 min-w-5 rounded-full bg-primary px-1 text-center text-[11px] font-semibold leading-5 text-primary-foreground">
          {n}
        </span>
      )}
    </Link>
  );
}

export function Layout() {
  const { me, signOut } = useAuth();
  const nav = useNavigate();
  const { pathname } = useLocation();
  const [q, setQ] = useState("");
  const [suggest, setSuggest] = useState<SuggestResponse | null>(null);
  const [openSuggest, setOpenSuggest] = useState(false);
  const searchBoxRef = useRef<HTMLFormElement>(null);

  useEffect(() => {
    window.scrollTo(0, 0);
    setOpenSuggest(false);
  }, [pathname]);

  useEffect(() => {
    const trimmed = q.trim();
    if (trimmed.length < 2) {
      setSuggest(null);
      return;
    }
    const t = setTimeout(() => {
      void api<SuggestResponse>("catalog/suggest", { q: trimmed, limit: 6 })
        .then((res) => setSuggest(res))
        .catch(() => undefined);
    }, 220);
    return () => clearTimeout(t);
  }, [q]);

  useEffect(() => {
    function onDocClick(e: MouseEvent) {
      if (searchBoxRef.current && !searchBoxRef.current.contains(e.target as Node)) {
        setOpenSuggest(false);
      }
    }
    document.addEventListener("mousedown", onDocClick);
    return () => document.removeEventListener("mousedown", onDocClick);
  }, []);

  const links = me ? LINKS[me.role] : [];
  const hasSuggest = Boolean(
    openSuggest && suggest && (suggest.products.length > 0 || suggest.categories.length > 0 || suggest.brands.length > 0),
  );

  return (
    <div className="min-h-dvh">
      <header className="sticky top-0 z-30 border-b bg-background/90 backdrop-blur">
        <div className="mx-auto flex h-14 max-w-6xl items-center gap-2.5 px-4">
          <Link to="/" className="flex shrink-0 items-center gap-2 font-semibold">
            <span className="flex size-8 items-center justify-center rounded-md bg-primary text-primary-foreground">
              <ShoppingBag className="size-4" aria-hidden />
            </span>
            <span className="hidden sm:inline">FDE Shop</span>
          </Link>

          <form
            ref={searchBoxRef}
            className="relative min-w-0 flex-1"
            role="search"
            onSubmit={(e) => {
              e.preventDefault();
              setOpenSuggest(false);
              nav(`/?q=${encodeURIComponent(q.trim())}`);
            }}
          >
            <Search className="pointer-events-none absolute top-1/2 left-2.5 size-4 -translate-y-1/2 text-muted-foreground" aria-hidden />
            <input
              aria-label="Search products"
              value={q}
              onFocus={() => setOpenSuggest(true)}
              onChange={(e) => {
                setQ(e.target.value);
                setOpenSuggest(true);
              }}
              placeholder="ค้นหาสินค้า แบรนด์ งบ เช่น 'สว่านมากิต้า งบ 3500' หรือ 'อาหารฮาลาล'"
              className="h-9 w-full rounded-md border bg-card pr-3 pl-8 text-sm focus-visible:outline-2 focus-visible:outline-ring"
            />

            {hasSuggest && suggest && (
              <div className="absolute top-11 right-0 left-0 z-40 max-h-96 overflow-y-auto rounded-lg border bg-card p-2 shadow-xl">
                {suggest.parsed_hints.length > 0 && (
                  <div className="mb-1.5 flex flex-wrap gap-1 px-1">
                    {suggest.parsed_hints.map((h) => (
                      <span key={h} className="rounded bg-primary/10 px-1.5 py-0.5 text-[11px] font-medium text-primary">
                        {h}
                      </span>
                    ))}
                  </div>
                )}
                {suggest.categories.length > 0 && (
                  <div className="mb-1.5 flex flex-wrap gap-1 border-b pb-1.5">
                    {suggest.categories.map((c) => (
                      <button
                        key={c.category_id}
                        type="button"
                        onClick={() => {
                          setOpenSuggest(false);
                          nav(`/?category_id=${c.category_id}`);
                        }}
                        className="rounded-full border bg-muted/40 px-2.5 py-0.5 text-xs hover:border-primary"
                      >
                        {c.icon} {c.name_th || c.name}
                      </button>
                    ))}
                  </div>
                )}
                {suggest.products.map((p) => (
                  <Link
                    key={p.product_id}
                    to={`/products/${p.product_id}`}
                    onClick={() => setOpenSuggest(false)}
                    className="flex items-center justify-between gap-2 rounded-md px-2 py-1.5 text-xs hover:bg-muted"
                  >
                    <span className="min-w-0 truncate">
                      <span className="font-medium">{p.name}</span>
                      {p.brand && <span className="ml-1.5 text-muted-foreground">({p.brand})</span>}
                    </span>
                    <span className="shrink-0 font-semibold text-accent">{baht(p.price)}</span>
                  </Link>
                ))}
              </div>
            )}
          </form>

          <NavLink
            to="/assistant"
            className={({ isActive }) =>
              cx(
                "inline-flex h-9 shrink-0 items-center gap-1.5 rounded-md border px-2.5 text-xs font-semibold transition-colors",
                isActive ? "border-primary bg-primary text-primary-foreground" : "border-primary/40 bg-primary/10 text-primary hover:bg-primary/20",
              )
            }
          >
            <Bot className="size-4" aria-hidden />
            <span className="hidden md:inline">น้องเอฟดี</span>
          </NavLink>

          {me?.role === "buyer" && <CartButton />}
          {me ? (
            <div className="flex shrink-0 items-center gap-1">
              <span className="hidden max-w-40 truncate text-sm text-muted-foreground md:inline" title={me.email}>
                {me.role === "seller" ? <Store className="mr-1 inline size-4" aria-hidden /> : <UserRound className="mr-1 inline size-4" aria-hidden />}
                {me.role === "seller" ? me.shop?.name : me.display_name}
              </span>
              <button
                type="button"
                onClick={() => void signOut().then(() => nav("/"))}
                aria-label="Sign out"
                className="inline-flex size-10 items-center justify-center rounded-md hover:bg-muted"
              >
                <LogOut className="size-4" aria-hidden />
              </button>
            </div>
          ) : (
            <Link to="/login" className="inline-flex h-9 shrink-0 items-center rounded-md bg-primary px-3 text-sm font-medium text-primary-foreground hover:bg-primary/90">
              Sign in
            </Link>
          )}
        </div>
        {links.length > 0 && (
          <nav aria-label="Account" className="mx-auto flex max-w-6xl gap-1 overflow-x-auto px-4 pb-2">
            {links.map((l) => (
              <NavLink
                key={l.to}
                to={l.to}
                end={l.end}
                className={({ isActive }) =>
                  cx(
                    "whitespace-nowrap rounded-md px-3 py-1.5 text-sm font-medium",
                    isActive ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:bg-muted hover:text-foreground",
                  )
                }
              >
                {l.label}
              </NavLink>
            ))}
          </nav>
        )}
      </header>
      <main className="mx-auto max-w-6xl px-4 py-6">
        <ErrorBoundary resetKey={pathname}>
          <Outlet />
        </ErrorBoundary>
      </main>
      <footer className="mx-auto max-w-6xl px-4 pb-8 text-xs text-muted-foreground">
        FDE 101 workshop marketplace · Smart Search &amp; AI Sales Concierge · demo data, no real payments
      </footer>
      <FloatingBot />
    </div>
  );
}

/** Pages for one role: others are sent to sign in (or home). The API and database check the same rule. */
export function RequireRole({ role, children }: { role: Role; children: ReactNode }) {
  const { me, loading } = useAuth();
  const { pathname, search } = useLocation();
  if (loading) return <div className="flex justify-center py-16" role="status"><Loader2 className="size-6 animate-spin text-muted-foreground" aria-label="Loading" /></div>;
  if (!me) return <Navigate to={`/login?next=${encodeURIComponent(pathname + search)}`} replace />;
  if (me.role !== role) return <Navigate to="/" replace />;
  return <>{children}</>;
}

export function RequireSignIn({ children }: { children: ReactNode }) {
  const { me, loading } = useAuth();
  const { pathname } = useLocation();
  if (loading) return <div className="flex justify-center py-16" role="status"><Loader2 className="size-6 animate-spin text-muted-foreground" aria-label="Loading" /></div>;
  if (!me) return <Navigate to={`/login?next=${encodeURIComponent(pathname)}`} replace />;
  return <>{children}</>;
}
