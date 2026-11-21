import { keepPreviousData, useQuery } from "@tanstack/react-query";
import { useCallback } from "react";
import { useSearchParams } from "react-router";
import { accessToken } from "./supabase";

export type Params = Record<string, string | number | boolean | null | undefined>;
export const UNAUTHORIZED_EVENT = "shop:unauthorized";

export class ApiError extends Error {
  constructor(public status: number, message: string) {
    super(message);
  }
}

async function request<T>(method: string, path: string, params?: Params, body?: unknown): Promise<T> {
  const qs = new URLSearchParams();
  for (const [k, v] of Object.entries(params ?? {})) if (v !== undefined && v !== null && v !== "") qs.set(k, String(v));
  const token = await accessToken();
  const res = await fetch(`/api/${path}${qs.size ? `?${qs}` : ""}`, {
    method,
    headers: { ...(token ? { Authorization: `Bearer ${token}` } : {}), ...(body !== undefined ? { "Content-Type": "application/json" } : {}) },
    body: body !== undefined ? JSON.stringify(body) : undefined,
  });
  if (res.status === 401 && token) dispatchEvent(new Event(UNAUTHORIZED_EVENT));
  if (!res.ok) {
    let detail: unknown = res.statusText;
    try {
      detail = (await res.json()).detail ?? detail;
    } catch {
      /* not JSON */
    }
    const msg = Array.isArray(detail) ? detail.map((d: { msg?: string }) => d.msg).join("; ") : String(detail);
    throw new ApiError(res.status, msg);
  }
  return res.json() as Promise<T>;
}

export const api = <T,>(path: string, params?: Params) => request<T>("GET", path, params);
export const apiSend = <T,>(method: "POST" | "PUT" | "DELETE", path: string, body?: unknown) => request<T>(method, path, undefined, body);

export function useApi<T>(path: string | null, params?: Params) {
  return useQuery({ queryKey: [path, params], queryFn: () => api<T>(path!, params), enabled: path !== null, placeholderData: keepPreviousData });
}

export function useUrlState<K extends string>(defaults: Record<K, string>) {
  const [sp, setSp] = useSearchParams();
  const values = Object.fromEntries((Object.keys(defaults) as K[]).map((k) => [k, sp.get(k) ?? defaults[k]])) as Record<K, string>;
  const set = useCallback(
    (patch: Partial<Record<K, string | number | null>>) => {
      setSp((prev) => {
        const next = new URLSearchParams(prev);
        for (const [k, v] of Object.entries(patch) as [string, string | number | null][]) {
          if (v === null || v === "" || String(v) === (defaults as Record<string, string>)[k]) next.delete(k);
          else next.set(k, String(v));
        }
        if (!("page" in patch)) next.delete("page");
        return next;
      }, { replace: true });
    },
    [setSp],
  );
  return [values, set] as const;
}

export const errorText = (e: unknown) => (e instanceof Error ? e.message : String(e));
