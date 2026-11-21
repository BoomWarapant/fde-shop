import { useQueryClient } from "@tanstack/react-query";
import { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from "react";
import { UNAUTHORIZED_EVENT } from "./api";
import { supabase } from "./supabase";

export type Role = "buyer" | "seller" | "admin";
export interface Me { user_id: string; email: string; display_name: string; role: Role; status: string; shop: { shop_id: number; name: string } | null }

interface AuthState {
  me: Me | null;
  loading: boolean;
  signIn: (email: string, password: string) => Promise<Me>;
  register: (b: { email: string; password: string; display_name: string; role: "buyer" | "seller"; shop_name?: string }) => Promise<Me>;
  signOut: () => Promise<void>;
}
const Ctx = createContext<AuthState | null>(null);

/** The server decides who we are (and whether the account is banned) on every call. */
async function fetchMe(token: string): Promise<Me | null> {
  const res = await fetch("/api/me", { headers: { Authorization: `Bearer ${token}` } });
  if (res.status === 401) return null;
  if (res.status === 403) throw new Error("This account is suspended. Contact the platform.");
  if (!res.ok) throw new Error(`Server error (${res.status})`);
  return res.json();
}

function friendly(m: string) {
  if (/invalid login credentials/i.test(m)) return "Email or password is incorrect.";
  if (/banned/i.test(m)) return "This account is suspended. Contact the platform.";
  return m;
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const qc = useQueryClient();
  const [me, setMe] = useState<Me | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let alive = true;
    supabase.auth.getSession()
      .then(async ({ data }) => {
        const m = data.session ? await fetchMe(data.session.access_token).catch(() => null) : null;
        if (data.session && !m) await supabase.auth.signOut({ scope: "local" });
        if (alive) setMe(m);
      })
      .finally(() => alive && setLoading(false));
    const { data: sub } = supabase.auth.onAuthStateChange((event) => {
      if (event === "SIGNED_OUT") { setMe(null); qc.clear(); }
    });
    const off = () => { setMe(null); qc.clear(); void supabase.auth.signOut({ scope: "local" }); };
    addEventListener(UNAUTHORIZED_EVENT, off);
    return () => { alive = false; sub.subscription.unsubscribe(); removeEventListener(UNAUTHORIZED_EVENT, off); };
  }, [qc]);

  const signIn = useCallback(async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signInWithPassword({ email: email.trim(), password });
    if (error) throw new Error(friendly(error.message));
    const m = await fetchMe(data.session.access_token);
    if (!m) { await supabase.auth.signOut({ scope: "local" }); throw new Error("Sign-in failed, please try again."); }
    qc.clear();
    setMe(m);
    return m;
  }, [qc]);

  const register = useCallback(async (b: { email: string; password: string; display_name: string; role: "buyer" | "seller"; shop_name?: string }) => {
    const res = await fetch("/api/register", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(b) });
    if (!res.ok) {
      let d: unknown = res.statusText;
      try { d = (await res.json()).detail; } catch { /* not JSON */ }
      const msg = Array.isArray(d) ? d.map((x: { msg?: string }) => x.msg).join("; ") : String(d);
      throw new Error(res.status === 409 ? "An account with this email already exists. Sign in instead." : msg);
    }
    return signIn(b.email, b.password);
  }, [signIn]);

  const signOut = useCallback(async () => {
    await supabase.auth.signOut().catch(() => undefined);
    qc.clear();
    setMe(null);
  }, [qc]);

  const value = useMemo(() => ({ me, loading, signIn, register, signOut }), [me, loading, signIn, register, signOut]);
  return <Ctx.Provider value={value}>{children}</Ctx.Provider>;
}

export function useAuth() {
  const v = useContext(Ctx);
  if (!v) throw new Error("useAuth must be used inside <AuthProvider>");
  return v;
}
