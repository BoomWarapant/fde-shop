import { useQueryClient } from "@tanstack/react-query";
import {
  ArrowRight,
  Bot,
  Check,
  Copy,
  GitCompare,
  Loader2,
  RotateCcw,
  Send,
  ShoppingCart,
  Sparkles,
  Store,
  Tag,
} from "lucide-react";
import { useEffect, useRef, useState } from "react";
import { Link, useNavigate } from "react-router";
import {
  BotText,
  TAG_LABEL_MAP,
  TRAIT_CHIPS,
  useBot,
  type BotCoupon,
  type BotProduct,
  type StageMode,
} from "../components/BotContext";
import { Badge, Card, cx } from "../components/ui";
import { apiSend, errorText, useApi } from "../lib/api";
import { useAuth } from "../lib/auth";
import { baht, num } from "../lib/format";
import type { Priced } from "./Cart";
import { couponText, ProductImage } from "./Catalog";

interface BotStatus {
  name: string;
  engine: string;
  llm_enabled: boolean;
  stats: { products: number; categories: number; shops: number; coupons: number };
  starter_prompts: string[];
}

export function AssistantPage() {
  const qc = useQueryClient();
  const nav = useNavigate();
  const { me } = useAuth();
  const status = useApi<BotStatus>("bot/status");
  const liveCart = useApi<Priced[]>(me?.role === "buyer" ? "cart" : null);

  const {
    messages,
    busy,
    stageMode,
    setStageMode,
    stageProducts,
    compareProducts,
    toggleCompare,
    stageCoupons,
    stageCart,
    dietaryTags,
    toggleDietaryTag,
    lastEngine,
    brainPath,
    sendMessage,
    resetChat,
  } = useBot();

  const [input, setInput] = useState("");
  const [qtyMap, setQtyMap] = useState<Record<number, number>>({});
  const [addedId, setAddedId] = useState<number | null>(null);
  const [copiedCode, setCopiedCode] = useState<string | null>(null);
  const [actionErr, setActionErr] = useState<string | null>(null);
  const endRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    endRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages.length, busy]);

  const effectiveCart = stageCart ?? liveCart.data ?? [];

  async function addToCart(p: BotProduct) {
    if (!me) {
      nav("/login?next=/assistant");
      return;
    }
    if (me.role !== "buyer") {
      setActionErr("เฉพาะบัญชีผู้ซื้อ (Buyer) เท่านั้นที่เพิ่มสินค้าลงตะกร้าได้ครับ");
      return;
    }
    const qty = Math.max(1, Math.min(99, qtyMap[p.product_id] ?? 1));
    setActionErr(null);
    try {
      await apiSend("PUT", `cart/${p.product_id}`, { qty });
      await qc.invalidateQueries({ queryKey: ["cart"] });
      setAddedId(p.product_id);
      setTimeout(() => setAddedId((cur) => (cur === p.product_id ? null : cur)), 1800);
    } catch (e) {
      setActionErr(errorText(e));
    }
  }

  function copyCode(code: string) {
    void navigator.clipboard?.writeText(code);
    setCopiedCode(code);
    setTimeout(() => setCopiedCode((c) => (c === code ? null : c)), 1500);
  }

  const stageTabs: { id: StageMode; label: string; count?: number }[] = [
    { id: "gallery", label: "เวทีสินค้า", count: stageProducts.length },
    { id: "compare", label: "เปรียบเทียบ", count: compareProducts.length },
    { id: "cart", label: "ตะกร้าสด", count: effectiveCart.reduce((a, g) => a + g.items.reduce((b, i) => b + i.qty, 0), 0) },
    { id: "coupons", label: "คูปอง", count: stageCoupons.length || status.data?.stats.coupons },
  ];

  const cheapestId =
    compareProducts.length >= 2
      ? compareProducts.reduce((best, p) => (p.price < best.price ? p : best), compareProducts[0]).product_id
      : null;
  const bestUnitId =
    compareProducts.length >= 2
      ? compareProducts.reduce(
          (best, p) => ((p.unit_price ?? p.price) < (best.unit_price ?? best.price) ? p : best),
          compareProducts[0],
        ).product_id
      : null;

  return (
    <div className="space-y-4">
      {/* Top Hero Banner */}
      <div className="flex flex-wrap items-center justify-between gap-3 rounded-xl border bg-gradient-to-r from-primary/10 via-card to-card p-4">
        <div className="flex items-center gap-3">
          <span className="flex size-11 shrink-0 items-center justify-center rounded-xl bg-primary text-primary-foreground shadow-sm">
            <Bot className="size-6" aria-hidden />
          </span>
          <div>
            <div className="flex flex-wrap items-center gap-2">
              <h1 className="text-lg font-semibold tracking-tight">น้องเอฟดี · Sales Concierge Cockpit</h1>
              <Badge tone={status.data?.llm_enabled ? "success" : "info"}>
                {status.data?.llm_enabled ? `Hybrid AI (${status.data.engine.replace("hybrid-llm:", "")})` : "Smart Search Engine"}
              </Badge>
            </div>
            <p className="text-xs text-muted-foreground">
              {status.data
                ? `เชื่อมต่อคลังจริง ${num(status.data.stats.products)} สินค้า · ${num(status.data.stats.categories)} หมวดหมู่หลัก · ${num(status.data.stats.shops)} ร้านค้า · ${num(status.data.stats.coupons)} คูปองสด`
                : "ค้นหาอัจฉริยะ เปรียบเทียบราคา และสั่งหยิบใส่ตะกร้าจริงได้ทันที"}
            </p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <Link to="/" className="inline-flex h-9 items-center gap-1.5 rounded-md border bg-card px-3 text-xs font-medium hover:bg-muted">
            ไปหน้าค้นหาละเอียด
          </Link>
          <button
            type="button"
            onClick={resetChat}
            className="inline-flex h-9 items-center gap-1.5 rounded-md border bg-card px-3 text-xs font-medium hover:bg-muted"
          >
            <RotateCcw className="size-3.5" aria-hidden /> เริ่มแชทใหม่
          </button>
        </div>
      </div>

      {/* Dietary / Trait Preference Bar (MarketBrain Dietary Shield style) */}
      <div className="flex flex-wrap items-center gap-1.5 rounded-lg border bg-card px-3 py-2">
        <span className="mr-1 text-xs font-medium text-muted-foreground">ตัวกรองพิเศษ:</span>
        {TRAIT_CHIPS.slice(0, 9).map((chip) => {
          const active = dietaryTags.includes(chip.id);
          return (
            <button
              key={chip.id}
              type="button"
              onClick={() => toggleDietaryTag(chip.id)}
              className={cx(
                "inline-flex items-center gap-1 rounded-full border px-2.5 py-1 text-xs font-medium transition-colors",
                active
                  ? "border-primary bg-primary text-primary-foreground"
                  : "bg-background text-muted-foreground hover:border-primary/50 hover:text-foreground",
              )}
            >
              <span>{chip.icon}</span>
              <span>{chip.label}</span>
            </button>
          );
        })}
        {dietaryTags.length > 0 && (
          <button
            type="button"
            onClick={() => dietaryTags.forEach(toggleDietaryTag)}
            className="ml-auto text-xs text-accent hover:underline"
          >
            ล้างตัวกรอง
          </button>
        )}
      </div>

      {/* Main Split Cockpit */}
      <div className="grid gap-4 lg:grid-cols-12">
        {/* LEFT: Chat Console */}
        <Card className="flex h-[min(680px,calc(100dvh-14rem))] flex-col overflow-hidden lg:col-span-5">
          <div className="flex items-center justify-between border-b px-4 py-2.5">
            <div className="flex items-center gap-2 text-sm font-semibold">
              <Sparkles className="size-4 text-primary" aria-hidden /> ห้องสนทนาปิดการขาย
            </div>
            <span className="font-mono text-[11px] text-muted-foreground">{lastEngine}</span>
          </div>

          <div className="flex-1 space-y-3 overflow-y-auto p-3.5">
            {messages.map((m) => (
              <div key={m.id} className={cx("flex flex-col gap-1.5", m.role === "user" ? "items-end" : "items-start")}>
                <div
                  className={cx(
                    "max-w-[94%] rounded-xl px-3.5 py-2.5",
                    m.role === "user" ? "bg-primary text-primary-foreground" : "border bg-muted/40 text-foreground",
                  )}
                >
                  <BotText text={m.content} />
                  {m.parsed_hints && m.parsed_hints.length > 0 && (
                    <div className="mt-2 flex flex-wrap gap-1">
                      {m.parsed_hints.map((h) => (
                        <span key={h} className="rounded bg-primary/10 px-1.5 py-0.5 text-[11px] font-medium text-primary">
                          {h}
                        </span>
                      ))}
                    </div>
                  )}
                </div>

                {m.role === "assistant" && m.suggestions && m.suggestions.length > 0 && (
                  <div className="flex flex-wrap gap-1.5">
                    {m.suggestions.map((s) => (
                      <button
                        key={s}
                        type="button"
                        disabled={busy}
                        onClick={() => void sendMessage(s)}
                        className="rounded-full border bg-card px-2.5 py-1 text-xs text-muted-foreground transition-colors hover:border-primary hover:text-foreground"
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
                <Loader2 className="size-4 animate-spin text-primary" /> น้องเอฟดีกำลังค้นสมองสินค้าและคำนวณความคุ้มค่า...
              </div>
            )}
            <div ref={endRef} />
          </div>

          <form
            className="flex items-center gap-2 border-t bg-background p-3"
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
              placeholder="พิมพ์หาสินค้า งบ หรือ 'เอาเบอร์ 1 จำนวน 2 ชิ้น'..."
              className="h-10 min-w-0 flex-1 rounded-md border bg-card px-3 text-sm focus-visible:outline-2 focus-visible:outline-ring"
            />
            <button
              type="submit"
              disabled={busy || !input.trim()}
              className="inline-flex h-10 items-center gap-1.5 rounded-md bg-primary px-3.5 text-sm font-medium text-primary-foreground hover:bg-primary/90 disabled:opacity-50"
            >
              <Send className="size-4" aria-hidden />
              <span className="hidden sm:inline">ส่ง</span>
            </button>
          </form>
        </Card>

        {/* RIGHT: Dynamic Visual Stage */}
        <Card className="flex h-[min(680px,calc(100dvh-14rem))] flex-col overflow-hidden lg:col-span-7">
          <div className="flex flex-wrap items-center justify-between gap-2 border-b px-3.5 py-2">
            <div role="tablist" className="flex flex-wrap gap-1">
              {stageTabs.map((t) => {
                const active = stageMode === t.id || (stageMode === "detail" && t.id === "gallery");
                return (
                  <button
                    key={t.id}
                    type="button"
                    role="tab"
                    aria-selected={active}
                    onClick={() => setStageMode(t.id)}
                    className={cx(
                      "inline-flex h-8 items-center gap-1.5 rounded-md px-2.5 text-xs font-medium transition-colors",
                      active ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:bg-muted hover:text-foreground",
                    )}
                  >
                    <span>{t.label}</span>
                    {t.count !== undefined && t.count > 0 && (
                      <span
                        className={cx(
                          "rounded-full px-1.5 py-0.2 text-[10px] font-semibold",
                          active ? "bg-primary-foreground/20 text-primary-foreground" : "bg-muted text-foreground",
                        )}
                      >
                        {t.count}
                      </span>
                    )}
                  </button>
                );
              })}
            </div>
            {compareProducts.length >= 2 && stageMode !== "compare" && (
              <button
                type="button"
                onClick={() => setStageMode("compare")}
                className="inline-flex items-center gap-1 rounded-md border border-primary/50 bg-primary/10 px-2.5 py-1 text-xs font-medium text-primary"
              >
                <GitCompare className="size-3.5" /> เทียบ {compareProducts.length} ตัว
              </button>
            )}
          </div>

          {/* Live Brain Path trace */}
          {brainPath && (stageMode === "gallery" || stageMode === "detail") && (
            <div className="flex flex-wrap items-center gap-1.5 border-b bg-muted/30 px-3.5 py-1.5 text-[11px] text-muted-foreground">
              <span className="font-semibold text-foreground">เส้นทางค้นหา:</span>
              <span className="rounded bg-card px-1.5 py-0.5 border">{brainPath.query}</span>
              {brainPath.categories.length > 0 && (
                <>
                  <ArrowRight className="size-3" />
                  <span className="rounded bg-success/10 px-1.5 py-0.5 text-success">{brainPath.categories.join(" · ")}</span>
                </>
              )}
              {brainPath.brands.length > 0 && (
                <>
                  <ArrowRight className="size-3" />
                  <span className="rounded bg-warning/10 px-1.5 py-0.5 text-warning">{brainPath.brands.join(" · ")}</span>
                </>
              )}
              {brainPath.tags.length > 0 && (
                <>
                  <ArrowRight className="size-3" />
                  <span className="rounded bg-primary/10 px-1.5 py-0.5 text-primary">{brainPath.tags.join(" · ")}</span>
                </>
              )}
            </div>
          )}

          {actionErr && (
            <div role="alert" className="border-b bg-destructive/10 px-4 py-2 text-xs text-destructive">
              {actionErr}
            </div>
          )}

          <div className="flex-1 overflow-y-auto p-3.5">
            {/* GALLERY / DETAIL STAGE */}
            {(stageMode === "gallery" || stageMode === "detail") && (
              stageProducts.length === 0 ? (
                <div className="flex h-full flex-col items-center justify-center gap-3 text-center">
                  <Sparkles className="size-8 text-primary/70" />
                  <div className="max-w-sm space-y-1">
                    <p className="text-sm font-medium">เวทีแสดงสินค้าสด (Visual Stage)</p>
                    <p className="text-xs text-muted-foreground">
                      ลองพิมพ์คุยกับน้องเอฟดีด้านซ้าย หรือคลิกตัวอย่างคำค้นด้านล่างเพื่อเรียกดูสินค้าพร้อมเลขเบอร์ #1, #2...
                    </p>
                  </div>
                  <div className="flex max-w-md flex-wrap justify-center gap-2">
                    {(status.data?.starter_prompts ?? []).map((p) => (
                      <button
                        key={p}
                        type="button"
                        onClick={() => void sendMessage(p)}
                        className="rounded-full border bg-card px-3 py-1.5 text-xs font-medium hover:border-primary hover:text-primary"
                      >
                        {p}
                      </button>
                    ))}
                  </div>
                </div>
              ) : stageMode === "detail" && stageProducts.length === 1 ? (
                <SpotlightProduct
                  p={stageProducts[0]}
                  qty={qtyMap[stageProducts[0].product_id] ?? 1}
                  onQty={(q) => setQtyMap((m) => ({ ...m, [stageProducts[0].product_id]: q }))}
                  added={addedId === stageProducts[0].product_id}
                  onAdd={() => void addToCart(stageProducts[0])}
                  coupons={stageCoupons}
                  onCopy={copyCode}
                  copiedCode={copiedCode}
                />
              ) : (
                <div className="grid gap-3 sm:grid-cols-2">
                  {stageProducts.map((p, idx) => {
                    const isCmp = compareProducts.some((c) => c.product_id === p.product_id);
                    const qty = qtyMap[p.product_id] ?? 1;
                    return (
                      <div key={p.product_id} className="flex flex-col rounded-lg border bg-card transition-colors hover:border-primary/50">
                        <div className="relative">
                          <ProductImage src={p.image_url} alt={p.name} className="aspect-[16/10] w-full rounded-t-lg object-cover" />
                          <span className="absolute top-2 left-2 rounded-md bg-foreground/85 px-2 py-0.5 text-xs font-bold text-background">
                            #{idx + 1}
                          </span>
                          {p.brand && (
                            <span className="absolute top-2 right-2 rounded bg-card/90 px-1.5 py-0.5 text-[11px] font-medium shadow-xs">
                              {p.brand}
                            </span>
                          )}
                        </div>
                        <div className="flex flex-1 flex-col gap-1.5 p-3">
                          <Link to={`/products/${p.product_id}`} className="line-clamp-2 text-sm font-medium hover:text-accent">
                            {p.name}
                          </Link>
                          <div className="flex items-baseline gap-1.5">
                            <span className="text-base font-semibold text-accent">{baht(p.price)}</span>
                            <span className="text-xs text-muted-foreground">/ {p.unit || "ชิ้น"}</span>
                            {(p.pack_qty ?? 1) > 1 && p.unit_price && (
                              <span className="text-[11px] text-success">({baht(p.unit_price)}/หน่วย)</span>
                            )}
                          </div>
                          {p.tags && p.tags.length > 0 && (
                            <div className="flex flex-wrap gap-1">
                              {p.tags.slice(0, 3).map((t) => (
                                <span key={t} className="rounded bg-muted px-1.5 py-0.5 text-[10px] text-muted-foreground">
                                  {TAG_LABEL_MAP[t]?.icon} {TAG_LABEL_MAP[t]?.label ?? t}
                                </span>
                              ))}
                            </div>
                          )}
                          <div className="mt-auto flex items-center justify-between pt-1 text-[11px] text-muted-foreground">
                            <span className="truncate">{p.shop}</span>
                            <span className={p.stock_qty > 0 ? "text-success" : "text-destructive"}>
                              {p.stock_qty > 0 ? `คงเหลือ ${num(p.stock_qty)}` : "สินค้าหมด"}
                            </span>
                          </div>
                          <div className="mt-1 flex items-center gap-1.5">
                            <input
                              type="number"
                              min={1}
                              max={Math.min(99, Math.max(1, p.stock_qty))}
                              value={qty}
                              onChange={(e) => setQtyMap((m) => ({ ...m, [p.product_id]: Math.max(1, Number(e.target.value) || 1) }))}
                              aria-label={`จำนวน ${p.name}`}
                              className="h-8 w-14 rounded-md border bg-background px-2 text-center text-xs tabular-nums"
                            />
                            <button
                              type="button"
                              disabled={p.stock_qty <= 0}
                              onClick={() => void addToCart(p)}
                              className="inline-flex h-8 flex-1 items-center justify-center gap-1 rounded-md bg-primary px-2.5 text-xs font-medium text-primary-foreground hover:bg-primary/90 disabled:opacity-40"
                            >
                              {addedId === p.product_id ? <Check className="size-3.5" /> : <ShoppingCart className="size-3.5" />}
                              <span>{addedId === p.product_id ? "ใส่แล้ว" : "ใส่ตะกร้า"}</span>
                            </button>
                            <button
                              type="button"
                              onClick={() => toggleCompare(p)}
                              title="เพิ่ม/เอาออกจากตารางเปรียบเทียบ"
                              className={cx(
                                "inline-flex size-8 shrink-0 items-center justify-center rounded-md border",
                                isCmp ? "border-primary bg-primary/10 text-primary" : "hover:bg-muted",
                              )}
                            >
                              <GitCompare className="size-3.5" aria-hidden />
                            </button>
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
              )
            )}

            {/* COMPARE STAGE */}
            {stageMode === "compare" && (
              compareProducts.length < 2 ? (
                <div className="flex h-full flex-col items-center justify-center gap-2 text-center text-sm text-muted-foreground">
                  <GitCompare className="size-7 opacity-60" />
                  <p>กดปุ่มเปรียบเทียบที่การ์ดสินค้าอย่างน้อย 2 ชิ้น หรือพิมพ์ &quot;เปรียบเทียบเบอร์ 1 กับ 2&quot;</p>
                </div>
              ) : (
                <div className="overflow-x-auto">
                  <table className="w-full border-collapse text-left text-xs">
                    <thead>
                      <tr className="border-b">
                        <th className="w-28 py-2 pr-3 font-medium text-muted-foreground">หัวข้อ</th>
                        {compareProducts.map((p, idx) => (
                          <th key={p.product_id} className="min-w-40 p-2 align-top">
                            <div className="mb-1 flex items-center justify-between">
                              <span className="font-bold text-primary">#{idx + 1}</span>
                              <button type="button" onClick={() => toggleCompare(p)} className="text-[11px] text-muted-foreground hover:text-destructive">
                                นำออก
                              </button>
                            </div>
                            <ProductImage src={p.image_url} alt={p.name} className="mb-1.5 aspect-[16/10] w-full rounded object-cover" />
                            <Link to={`/products/${p.product_id}`} className="line-clamp-2 font-semibold hover:text-accent">
                              {p.name}
                            </Link>
                          </th>
                        ))}
                      </tr>
                    </thead>
                    <tbody className="divide-y">
                      <tr>
                        <td className="py-2 pr-3 text-muted-foreground">ราคาขาย</td>
                        {compareProducts.map((p) => (
                          <td key={p.product_id} className="p-2 font-semibold text-accent">
                            {baht(p.price)}
                            {p.product_id === cheapestId && <Badge tone="success"> ถูกสุด</Badge>}
                          </td>
                        ))}
                      </tr>
                      <tr>
                        <td className="py-2 pr-3 text-muted-foreground">หน่วย / เฉลี่ย</td>
                        {compareProducts.map((p) => (
                          <td key={p.product_id} className="p-2">
                            {p.unit || "ชิ้น"} ({baht(p.unit_price ?? p.price)}/หน่วย)
                            {p.product_id === bestUnitId && <Badge tone="info"> คุ้มสุด</Badge>}
                          </td>
                        ))}
                      </tr>
                      <tr>
                        <td className="py-2 pr-3 text-muted-foreground">แบรนด์</td>
                        {compareProducts.map((p) => <td key={p.product_id} className="p-2">{p.brand || "—"}</td>)}
                      </tr>
                      <tr>
                        <td className="py-2 pr-3 text-muted-foreground">ร้านค้า</td>
                        {compareProducts.map((p) => <td key={p.product_id} className="p-2">{p.shop}</td>)}
                      </tr>
                      <tr>
                        <td className="py-2 pr-3 text-muted-foreground">สต็อก</td>
                        {compareProducts.map((p) => (
                          <td key={p.product_id} className="p-2">{p.stock_qty > 0 ? `${num(p.stock_qty)} พร้อมส่ง` : "หมด"}</td>
                        ))}
                      </tr>
                      <tr>
                        <td className="py-2 pr-3 text-muted-foreground">จุดเด่น</td>
                        {compareProducts.map((p) => (
                          <td key={p.product_id} className="p-2">
                            <div className="flex flex-wrap gap-1">
                              {(p.tags ?? []).map((t) => (
                                <span key={t} className="rounded bg-muted px-1.5 py-0.5 text-[10px]">
                                  {TAG_LABEL_MAP[t]?.icon} {TAG_LABEL_MAP[t]?.label ?? t}
                                </span>
                              ))}
                            </div>
                          </td>
                        ))}
                      </tr>
                      <tr>
                        <td className="py-2 pr-3 text-muted-foreground">เลือกซื้อ</td>
                        {compareProducts.map((p) => (
                          <td key={p.product_id} className="p-2">
                            <button
                              type="button"
                              disabled={p.stock_qty <= 0}
                              onClick={() => void addToCart(p)}
                              className="inline-flex h-8 w-full items-center justify-center gap-1 rounded-md bg-primary px-2 text-xs font-medium text-primary-foreground hover:bg-primary/90 disabled:opacity-40"
                            >
                              <ShoppingCart className="size-3.5" /> {addedId === p.product_id ? "ใส่แล้ว" : "ใส่ตะกร้า"}
                            </button>
                          </td>
                        ))}
                      </tr>
                    </tbody>
                  </table>
                </div>
              )
            )}

            {/* LIVE CART STAGE */}
            {stageMode === "cart" && (
              !me ? (
                <div className="flex h-full flex-col items-center justify-center gap-3 text-center">
                  <ShoppingCart className="size-8 text-muted-foreground" />
                  <p className="text-sm text-muted-foreground">เข้าสู่ระบบด้วยบัญชีผู้ซื้อเพื่อดูตะกร้าสดและปิดการขาย</p>
                  <Link to="/login?next=/assistant" className="rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground">
                    เข้าสู่ระบบ
                  </Link>
                </div>
              ) : effectiveCart.length === 0 ? (
                <div className="flex h-full flex-col items-center justify-center gap-2 text-center text-sm text-muted-foreground">
                  <ShoppingCart className="size-8 opacity-60" />
                  <p>ตะกร้ายังว่างอยู่ครับ สั่งน้องเอฟดี &quot;เอาเบอร์ 1 ใส่ตะกร้า&quot; หรือกดปุ่มที่การ์ดสินค้าได้เลย</p>
                </div>
              ) : (
                <div className="space-y-3">
                  {effectiveCart.map((g) => {
                    const freePct = Math.min(100, Math.round((g.subtotal / 500) * 100));
                    const gap = Math.max(0, 500 - g.subtotal);
                    return (
                      <div key={g.shop_id} className="rounded-lg border p-3 space-y-2">
                        <div className="flex items-center justify-between">
                          <span className="inline-flex items-center gap-1.5 text-sm font-semibold">
                            <Store className="size-4 text-primary" /> {g.shop}
                          </span>
                          <span className="text-sm font-bold text-accent">{baht(g.total)}</span>
                        </div>
                        {/* Free shipping meter */}
                        <div className="space-y-1">
                          <div className="flex justify-between text-[11px] text-muted-foreground">
                            <span>{gap > 0 ? `ซื้อเพิ่มอีก ${baht(gap)} ได้ส่งฟรี (ประหยัด ฿40)` : "🎉 ได้สิทธิ์ส่งฟรีแล้ว!"}</span>
                            <span>{freePct}%</span>
                          </div>
                          <div className="h-1.5 w-full overflow-hidden rounded-full bg-muted">
                            <div className={cx("h-full transition-all", gap === 0 ? "bg-success" : "bg-primary")} style={{ width: `${freePct}%` }} />
                          </div>
                        </div>
                        <ul className="divide-y text-xs">
                          {g.items.map((it) => (
                            <li key={it.product_id} className="flex justify-between gap-2 py-1.5">
                              <span className="truncate">{it.name} × {it.qty}</span>
                              <span className="shrink-0 tabular-nums font-medium">{baht(it.line_total)}</span>
                            </li>
                          ))}
                        </ul>
                        <div className="flex items-center justify-between border-t pt-2 text-xs text-muted-foreground">
                          <span>ค่าส่ง: {g.shipping_fee ? baht(g.shipping_fee) : "ฟรี"}</span>
                          {g.discount > 0 && <span className="text-success">ส่วนลด: −{baht(g.discount)}</span>}
                        </div>
                      </div>
                    );
                  })}
                  <Link
                    to="/cart"
                    className="inline-flex h-10 w-full items-center justify-center gap-2 rounded-md bg-primary text-sm font-semibold text-primary-foreground hover:bg-primary/90"
                  >
                    ไปหน้าตะกร้าและปิดบิลชำระเงิน <ArrowRight className="size-4" />
                  </Link>
                </div>
              )
            )}

            {/* COUPONS STAGE */}
            {stageMode === "coupons" && (
              <div className="space-y-2.5">
                {stageCoupons.length === 0 ? (
                  <div className="py-12 text-center text-sm text-muted-foreground">
                    พิมพ์ &quot;มีคูปองส่วนลดอะไรบ้าง&quot; เพื่อให้น้องเอฟดีดึงโค้ดล่าสุดทั้งหมดครับ
                  </div>
                ) : (
                  stageCoupons.map((c) => (
                    <div key={c.code} className="flex items-center justify-between gap-3 rounded-lg border border-dashed border-primary/60 bg-primary/5 p-3">
                      <div className="min-w-0">
                        <div className="flex items-center gap-2">
                          <Tag className="size-4 text-primary" />
                          <span className="font-mono text-sm font-bold">{c.code}</span>
                          <Badge tone={c.platform ? "success" : "info"}>{c.platform ? "คูปองแพลตฟอร์ม" : c.shop || "คูปองร้านค้า"}</Badge>
                        </div>
                        <p className="mt-1 text-xs text-muted-foreground">{couponText(c)}</p>
                      </div>
                      <button
                        type="button"
                        onClick={() => copyCode(c.code)}
                        className="inline-flex h-8 shrink-0 items-center gap-1 rounded-md border bg-card px-2.5 text-xs font-medium hover:bg-muted"
                      >
                        {copiedCode === c.code ? <Check className="size-3.5 text-success" /> : <Copy className="size-3.5" />}
                        <span>{copiedCode === c.code ? "คัดลอกแล้ว" : "คัดลอก"}</span>
                      </button>
                    </div>
                  ))
                )}
              </div>
            )}
          </div>
        </Card>
      </div>
    </div>
  );
}

function SpotlightProduct({
  p,
  qty,
  onQty,
  added,
  onAdd,
  coupons,
  onCopy,
  copiedCode,
}: {
  p: BotProduct;
  qty: number;
  onQty: (n: number) => void;
  added: boolean;
  onAdd: () => void;
  coupons: BotCoupon[];
  onCopy: (code: string) => void;
  copiedCode: string | null;
}) {
  return (
    <div className="space-y-4">
      <div className="grid gap-4 sm:grid-cols-2">
        <ProductImage src={p.image_url} alt={p.name} className="aspect-square w-full rounded-lg border object-cover" />
        <div className="space-y-2.5">
          <div className="text-xs text-muted-foreground">
            {p.parent_category_th || p.parent_category} {p.category_th ? `› ${p.category_th}` : ""}
          </div>
          <h2 className="text-base font-semibold">{p.name}</h2>
          {p.brand && <div className="text-xs text-muted-foreground">แบรนด์: <b className="text-foreground">{p.brand}</b></div>}
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold text-accent">{baht(p.price)}</span>
            <span className="text-xs text-muted-foreground">/ {p.unit || "ชิ้น"}</span>
          </div>
          {(p.pack_qty ?? 1) > 1 && p.unit_price && (
            <div className="text-xs text-success">บรรจุ {p.pack_qty} หน่วย · เฉลี่ย {baht(p.unit_price)} ต่อหน่วย</div>
          )}
          <div className="text-xs text-muted-foreground">
            ร้าน: <Link to={`/shops/${p.shop_id}`} className="font-medium text-foreground hover:text-accent">{p.shop}</Link> ·{" "}
            {p.stock_qty > 0 ? `คงเหลือ ${num(p.stock_qty)}` : "สินค้าหมด"}
          </div>
          {p.tags && p.tags.length > 0 && (
            <div className="flex flex-wrap gap-1">
              {p.tags.map((t) => (
                <Badge key={t} tone="neutral">
                  {TAG_LABEL_MAP[t]?.icon} {TAG_LABEL_MAP[t]?.label ?? t}
                </Badge>
              ))}
            </div>
          )}
          <div className="flex items-center gap-2 pt-2">
            <input
              type="number"
              min={1}
              max={Math.min(99, Math.max(1, p.stock_qty))}
              value={qty}
              onChange={(e) => onQty(Math.max(1, Number(e.target.value) || 1))}
              className="h-9 w-16 rounded-md border bg-background px-2 text-center text-sm"
            />
            <button
              type="button"
              disabled={p.stock_qty <= 0}
              onClick={onAdd}
              className="inline-flex h-9 flex-1 items-center justify-center gap-1.5 rounded-md bg-primary px-3 text-sm font-medium text-primary-foreground hover:bg-primary/90 disabled:opacity-40"
            >
              {added ? <Check className="size-4" /> : <ShoppingCart className="size-4" />}
              <span>{added ? "เพิ่มลงตะกร้าแล้ว" : "ใส่ตะกร้า"}</span>
            </button>
          </div>
          <Link to={`/products/${p.product_id}`} className="inline-block text-xs text-accent hover:underline">
            เปิดหน้าสินค้าฉบับเต็ม →
          </Link>
        </div>
      </div>
      {p.description && <p className="rounded-lg bg-muted/40 p-3 text-xs leading-relaxed text-muted-foreground">{p.description}</p>}
      {coupons.length > 0 && (
        <div className="flex flex-wrap gap-2">
          {coupons.slice(0, 3).map((c) => (
            <button
              key={c.code}
              type="button"
              onClick={() => onCopy(c.code)}
              className="inline-flex items-center gap-1.5 rounded-md border border-dashed border-primary px-2.5 py-1 text-xs hover:bg-primary/5"
            >
              <Tag className="size-3.5 text-primary" />
              <b className="font-mono">{c.code}</b> · {couponText(c)}
              {copiedCode === c.code && <span className="text-success">(คัดลอกแล้ว)</span>}
            </button>
          ))}
        </div>
      )}
    </div>
  );
}
