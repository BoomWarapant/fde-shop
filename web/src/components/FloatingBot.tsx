import { useQueryClient } from "@tanstack/react-query";
import { Bot, Check, ExternalLink, Loader2, Maximize2, Send, ShoppingCart, Sparkles, X } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import { Link, useLocation, useNavigate } from "react-router";
import { apiSend, errorText } from "../lib/api";
import { useAuth } from "../lib/auth";
import { baht } from "../lib/format";
import { ProductImage } from "../pages/Catalog";
import { BotText, useBot, type BotProduct } from "./BotContext";
import { cx } from "./ui";

export function FloatingBot() {
  const { pathname } = useLocation();
  const nav = useNavigate();
  const qc = useQueryClient();
  const { me } = useAuth();
  const { messages, busy, drawerOpen, setDrawerOpen, sendMessage } = useBot();
  const [input, setInput] = useState("");
  const [addedId, setAddedId] = useState<number | null>(null);
  const [cartErr, setCartErr] = useState<string | null>(null);
  const endRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (drawerOpen) endRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [drawerOpen, messages.length, busy]);

  // Hide floating launcher when already on the full Sales Cockpit page
  if (pathname === "/assistant") return null;

  async function quickAdd(p: BotProduct) {
    if (!me) {
      setDrawerOpen(false);
      nav(`/login?next=${encodeURIComponent(pathname)}`);
      return;
    }
    if (me.role !== "buyer") {
      setCartErr("เฉพาะบัญชีผู้ซื้อ (Buyer) เท่านั้นที่ใส่ตะกร้าได้ครับ");
      return;
    }
    setCartErr(null);
    try {
      await apiSend("PUT", `cart/${p.product_id}`, { qty: 1 });
      await qc.invalidateQueries({ queryKey: ["cart"] });
      setAddedId(p.product_id);
      setTimeout(() => setAddedId((cur) => (cur === p.product_id ? null : cur)), 1800);
    } catch (e) {
      setCartErr(errorText(e));
    }
  }

  return (
    <>
      {!drawerOpen && (
        <button
          type="button"
          onClick={() => setDrawerOpen(true)}
          className="fixed right-4 bottom-4 z-40 inline-flex items-center gap-2 rounded-full bg-primary px-4 py-3 text-sm font-semibold text-primary-foreground shadow-lg transition-transform hover:scale-[1.02] hover:bg-primary/90"
          aria-label="เปิดบอทช่วยหาสินค้า น้องเอฟดี"
        >
          <Sparkles className="size-4" aria-hidden />
          <span>น้องเอฟดี ช่วยช้อป</span>
        </button>
      )}

      {drawerOpen && (
        <aside
          aria-label="น้องเอฟดี ผู้ช่วยค้นหาและขายสินค้า"
          className="fixed right-3 bottom-3 z-50 flex h-[min(620px,calc(100dvh-5rem))] w-[min(410px,calc(100vw-1.5rem))] flex-col overflow-hidden rounded-xl border bg-card shadow-2xl"
        >
          <header className="flex items-center justify-between gap-2 border-b bg-primary/10 px-3.5 py-2.5">
            <div className="flex min-w-0 items-center gap-2">
              <span className="flex size-8 shrink-0 items-center justify-center rounded-full bg-primary text-primary-foreground">
                <Bot className="size-4" aria-hidden />
              </span>
              <div className="min-w-0">
                <div className="truncate text-sm font-semibold">น้องเอฟดี · Sales Concierge</div>
                <div className="truncate text-[11px] text-muted-foreground">ค้นสินค้า เทียบราคา หยิบใส่ตะกร้าสด</div>
              </div>
            </div>
            <div className="flex items-center gap-1">
              <Link
                to="/assistant"
                onClick={() => setDrawerOpen(false)}
                title="เปิดจอเต็ม Sales Cockpit"
                className="inline-flex size-8 items-center justify-center rounded-md hover:bg-muted"
              >
                <Maximize2 className="size-4" aria-hidden />
              </Link>
              <button
                type="button"
                onClick={() => setDrawerOpen(false)}
                aria-label="ปิดหน้าต่างบอท"
                className="inline-flex size-8 items-center justify-center rounded-md hover:bg-muted"
              >
                <X className="size-4" aria-hidden />
              </button>
            </div>
          </header>

          <div className="flex-1 space-y-3 overflow-y-auto p-3">
            {messages.map((m) => (
              <div key={m.id} className={cx("flex flex-col gap-1.5", m.role === "user" ? "items-end" : "items-start")}>
                <div
                  className={cx(
                    "max-w-[92%] rounded-xl px-3 py-2",
                    m.role === "user" ? "bg-primary text-primary-foreground" : "border bg-muted/40 text-foreground",
                  )}
                >
                  <BotText text={m.content} />
                  {m.parsed_hints && m.parsed_hints.length > 0 && (
                    <div className="mt-1.5 flex flex-wrap gap-1">
                      {m.parsed_hints.map((h) => (
                        <span key={h} className="rounded bg-primary/10 px-1.5 py-0.5 text-[11px] font-medium text-primary">
                          {h}
                        </span>
                      ))}
                    </div>
                  )}
                </div>

                {m.role === "assistant" && m.products && m.products.length > 0 && (
                  <div className="w-full space-y-1.5">
                    {m.products.slice(0, 4).map((p, idx) => (
                      <div key={p.product_id} className="flex items-center gap-2 rounded-lg border bg-card p-2">
                        <span className="flex size-5 shrink-0 items-center justify-center rounded bg-primary/15 text-[11px] font-bold text-primary">
                          {idx + 1}
                        </span>
                        <ProductImage src={p.image_url} alt={p.name} className="size-11 shrink-0 rounded object-cover" />
                        <div className="min-w-0 flex-1">
                          <Link
                            to={`/products/${p.product_id}`}
                            onClick={() => setDrawerOpen(false)}
                            className="line-clamp-1 text-xs font-medium hover:text-accent"
                          >
                            {p.name}
                          </Link>
                          <div className="flex items-center gap-1.5 text-xs">
                            <span className="font-semibold text-accent">{baht(p.price)}</span>
                            <span className="text-[11px] text-muted-foreground">/ {p.unit || "ชิ้น"}</span>
                          </div>
                        </div>
                        <button
                          type="button"
                          disabled={p.stock_qty <= 0}
                          onClick={() => void quickAdd(p)}
                          className="inline-flex h-7 shrink-0 items-center gap-1 rounded-md bg-primary px-2 text-[11px] font-medium text-primary-foreground hover:bg-primary/90 disabled:opacity-40"
                        >
                          {addedId === p.product_id ? <Check className="size-3" /> : <ShoppingCart className="size-3" />}
                          <span>{addedId === p.product_id ? "ใส่แล้ว" : "ใส่ตะกร้า"}</span>
                        </button>
                      </div>
                    ))}
                    {m.products.length > 4 && (
                      <Link
                        to="/assistant"
                        onClick={() => setDrawerOpen(false)}
                        className="inline-flex items-center gap-1 text-xs font-medium text-accent hover:underline"
                      >
                        ดูทั้งหมด {m.products.length} รายการบน Sales Cockpit <ExternalLink className="size-3" />
                      </Link>
                    )}
                  </div>
                )}

                {m.role === "assistant" && m.suggestions && m.suggestions.length > 0 && (
                  <div className="flex flex-wrap gap-1.5">
                    {m.suggestions.map((s) => (
                      <button
                        key={s}
                        type="button"
                        disabled={busy}
                        onClick={() => void sendMessage(s)}
                        className="rounded-full border bg-card px-2.5 py-1 text-xs text-muted-foreground hover:border-primary hover:text-foreground"
                      >
                        {s}
                      </button>
                    ))}
                  </div>
                )}
              </div>
            ))}
            {busy && (
              <div className="flex items-center gap-2 text-xs text-muted-foreground">
                <Loader2 className="size-3.5 animate-spin" /> น้องเอฟดีกำลังค้นคลังสินค้า...
              </div>
            )}
            {cartErr && <p className="text-xs text-destructive">{cartErr}</p>}
            <div ref={endRef} />
          </div>

          <form
            className="flex items-center gap-2 border-t bg-background p-2.5"
            onSubmit={(e) => {
              e.preventDefault();
              if (!input.trim()) return;
              const txt = input;
              setInput("");
              void sendMessage(txt);
            }}
          >
            <input
              value={input}
              onChange={(e) => setInput(e.target.value)}
              placeholder="พิมพ์หาสินค้า งบ หรือ 'เอาเบอร์ 1 2 ชิ้น'..."
              className="h-9 min-w-0 flex-1 rounded-md border bg-card px-3 text-sm focus-visible:outline-2 focus-visible:outline-ring"
            />
            <button
              type="submit"
              disabled={busy || !input.trim()}
              aria-label="ส่งข้อความ"
              className="inline-flex size-9 shrink-0 items-center justify-center rounded-md bg-primary text-primary-foreground hover:bg-primary/90 disabled:opacity-50"
            >
              <Send className="size-4" aria-hidden />
            </button>
          </form>
        </aside>
      )}
    </>
  );
}
