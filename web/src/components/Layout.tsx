import { Loader2, LogOut, Search, ShoppingBag, ShoppingCart, Store, UserRound } from "lucide-react";
import { useEffect, useState, type ReactNode } from "react";
import { Link, Navigate, NavLink, Outlet, useLocation, useNavigate } from "react-router";
import { useApi } from "../lib/api";
import { useAuth, type Role } from "../lib/auth";
import { ErrorBoundary } from "./ErrorBoundary";
import { cx } from "./ui";

interface CartShop { items: { qty: number }[] }

const LINKS: Record<Role, { to: string; label: string; end?: boolean }[]> = {
  buyer: [{ to: "/orders", label: "My orders" }],
  seller: [{ to: "/seller", label: "Overview", end: true }, { to: "/seller/products", label: "Products" }, { to: "/seller/orders", label: "Orders" },
    { to: "/seller/promotions", label: "Promotions" }, { to: "/seller/accounting", label: "Accounting" }, { to: "/seller/customers", label: "Customers" }],
  admin: [{ to: "/admin", label: "Overview", end: true }, { to: "/admin/users", label: "Users" }, { to: "/admin/campaigns", label: "Campaigns" }],
};

function CartButton() {
  const { data } = useApi<CartShop[]>("cart");
  const n = (data ?? []).reduce((a, s) => a + s.items.reduce((b, i) => b + i.qty, 0), 0);
  return (
    <Link to="/cart" aria-label={`Cart, ${n} items`} className="relative inline-flex size-10 items-center justify-center rounded-md hover:bg-muted">
      <ShoppingCart className="size-5" aria-hidden />
      {n > 0 && <span className="absolute -top-0.5 -right-0.5 min-w-5 rounded-full bg-primary px-1 text-center text-[11px] font-semibold leading-5 text-primary-foreground">{n}</span>}
    </Link>
  );
}

export function Layout() {
  const { me, signOut } = useAuth();
  const nav = useNavigate();
  const { pathname } = useLocation();
  const [q, setQ] = useState("");
  useEffect(() => { window.scrollTo(0, 0); }, [pathname]);
  const links = me ? LINKS[me.role] : [];
  return (
    <div className="min-h-dvh">
      <header className="sticky top-0 z-30 border-b bg-background/90 backdrop-blur">
        <div className="mx-auto flex h-14 max-w-6xl items-center gap-3 px-4">
          <Link to="/" className="flex shrink-0 items-center gap-2 font-semibold">
            <span className="flex size-8 items-center justify-center rounded-md bg-primary text-primary-foreground"><ShoppingBag className="size-4" aria-hidden /></span>
            <span className="hidden sm:inline">FDE Shop</span>
          </Link>
          <form className="relative min-w-0 flex-1" role="search" onSubmit={(e) => { e.preventDefault(); nav(`/?q=${encodeURIComponent(q.trim())}`); }}>
            <Search className="pointer-events-none absolute top-1/2 left-2.5 size-4 -translate-y-1/2 text-muted-foreground" aria-hidden />
            <input aria-label="Search products" value={q} onChange={(e) => setQ(e.target.value)} placeholder="Search products or shops"
              className="h-9 w-full rounded-md border bg-card pr-3 pl-8 text-sm focus-visible:outline-2 focus-visible:outline-ring" />
          </form>
          {me?.role === "buyer" && <CartButton />}
          {me ? (
            <div className="flex shrink-0 items-center gap-1">
              <span className="hidden max-w-40 truncate text-sm text-muted-foreground md:inline" title={me.email}>
                {me.role === "seller" ? <Store className="mr-1 inline size-4" aria-hidden /> : <UserRound className="mr-1 inline size-4" aria-hidden />}
                {me.role === "seller" ? me.shop?.name : me.display_name}
              </span>
              <button type="button" onClick={() => void signOut().then(() => nav("/"))} aria-label="Sign out"
                className="inline-flex size-10 items-center justify-center rounded-md hover:bg-muted"><LogOut className="size-4" aria-hidden /></button>
            </div>
          ) : (
            <Link to="/login" className="inline-flex h-9 shrink-0 items-center rounded-md bg-primary px-3 text-sm font-medium text-primary-foreground hover:bg-primary/90">Sign in</Link>
          )}
        </div>
        {links.length > 0 && (
          <nav aria-label="Account" className="mx-auto flex max-w-6xl gap-1 overflow-x-auto px-4 pb-2">
            {links.map((l) => (
              <NavLink key={l.to} to={l.to} end={l.end} className={({ isActive }) => cx("whitespace-nowrap rounded-md px-3 py-1.5 text-sm font-medium",
                isActive ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:bg-muted hover:text-foreground")}>{l.label}</NavLink>
            ))}
          </nav>
        )}
      </header>
      <main className="mx-auto max-w-6xl px-4 py-6">
        <ErrorBoundary resetKey={pathname}><Outlet /></ErrorBoundary>
      </main>
      <footer className="mx-auto max-w-6xl px-4 pb-8 text-xs text-muted-foreground">FDE 101 workshop marketplace · demo data, no real payments</footer>
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
