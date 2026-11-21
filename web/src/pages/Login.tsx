import { Loader2 } from "lucide-react";
import { useState, type FormEvent } from "react";
import { Link, Navigate, useNavigate, useSearchParams } from "react-router";
import { Card } from "../components/ui";
import { errorText } from "../lib/api";
import { useAuth, type Me } from "../lib/auth";

const input = "mt-1 h-10 w-full rounded-md border bg-card px-3 text-sm focus-visible:outline-2 focus-visible:outline-ring";
const home = (m: Me) => (m.role === "seller" ? "/seller" : m.role === "admin" ? "/admin" : "/");

export function LoginPage() {
  const { me, signIn } = useAuth();
  const nav = useNavigate();
  const [sp] = useSearchParams();
  const [err, setErr] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  if (me) return <Navigate to={sp.get("next") || home(me)} replace />;
  async function submit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const f = new FormData(e.currentTarget);
    setBusy(true); setErr(null);
    try { const m = await signIn(String(f.get("email")), String(f.get("password"))); nav(sp.get("next") || home(m), { replace: true }); }
    catch (x) { setErr(errorText(x)); } finally { setBusy(false); }
  }
  return (
    <Card className="mx-auto max-w-sm p-6">
      <h1 className="mb-4 text-lg font-semibold">Sign in</h1>
      <form onSubmit={submit} className="space-y-3">
        <label className="block text-sm">Email<input name="email" type="email" autoComplete="email" required className={input} /></label>
        <label className="block text-sm">Password<input name="password" type="password" autoComplete="current-password" required className={input} /></label>
        {err && <p role="alert" className="text-sm text-destructive">{err}</p>}
        <button disabled={busy} className="inline-flex h-10 w-full items-center justify-center gap-2 rounded-md bg-primary text-sm font-medium text-primary-foreground disabled:opacity-60">
          {busy && <Loader2 className="size-4 animate-spin" aria-hidden />} Sign in</button>
      </form>
      <p className="mt-4 text-center text-sm">New here? <Link to="/register" className="text-accent underline">Create an account</Link></p>
    </Card>
  );
}

export function RegisterPage() {
  const { me, register } = useAuth();
  const nav = useNavigate();
  const [role, setRole] = useState<"buyer" | "seller">("buyer");
  const [err, setErr] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  if (me) return <Navigate to={home(me)} replace />;
  async function submit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const f = new FormData(e.currentTarget);
    setBusy(true); setErr(null);
    try {
      const m = await register({ email: String(f.get("email")), password: String(f.get("password")), display_name: String(f.get("display_name")),
        role, shop_name: role === "seller" ? String(f.get("shop_name")) : undefined });
      nav(home(m), { replace: true });
    } catch (x) { setErr(errorText(x)); } finally { setBusy(false); }
  }
  return (
    <Card className="mx-auto max-w-sm p-6">
      <h1 className="mb-4 text-lg font-semibold">Create an account</h1>
      <div role="radiogroup" aria-label="Account type" className="mb-4 grid grid-cols-2 gap-2">
        {(["buyer", "seller"] as const).map((r) => (
          <button key={r} type="button" role="radio" aria-checked={role === r} onClick={() => setRole(r)}
            className={"rounded-md border px-3 py-2 text-sm font-medium " + (role === r ? "border-primary bg-primary/10 text-primary" : "hover:bg-muted")}>
            {r === "buyer" ? "I want to buy" : "I want to sell"}</button>
        ))}
      </div>
      <form onSubmit={submit} className="space-y-3">
        <label className="block text-sm">Your name<input name="display_name" required minLength={2} maxLength={60} className={input} /></label>
        {role === "seller" && <label className="block text-sm">Shop name<input name="shop_name" required minLength={2} maxLength={60} className={input} /></label>}
        <label className="block text-sm">Email<input name="email" type="email" autoComplete="email" required className={input} /></label>
        <label className="block text-sm">Password (8+ characters)<input name="password" type="password" autoComplete="new-password" required minLength={8} className={input} /></label>
        {err && <p role="alert" className="text-sm text-destructive">{err}</p>}
        <button disabled={busy} className="inline-flex h-10 w-full items-center justify-center gap-2 rounded-md bg-primary text-sm font-medium text-primary-foreground disabled:opacity-60">
          {busy && <Loader2 className="size-4 animate-spin" aria-hidden />} Create {role} account</button>
      </form>
      <p className="mt-4 text-center text-sm">Have an account? <Link to="/login" className="text-accent underline">Sign in</Link></p>
    </Card>
  );
}
