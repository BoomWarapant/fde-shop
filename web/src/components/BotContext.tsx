import { useQueryClient } from "@tanstack/react-query";
import { createContext, useCallback, useContext, useMemo, useState, type ReactNode } from "react";
import { apiSend, errorText } from "../lib/api";
import type { Priced } from "../pages/Cart";

export interface BotProduct {
  product_id: number;
  name: string;
  description?: string | null;
  price: number;
  unit_price?: number;
  image_url: string | null;
  stock_qty: number;
  category_id?: number | null;
  parent_category_id?: number | null;
  category?: string | null;
  category_th?: string | null;
  parent_category?: string | null;
  parent_category_th?: string | null;
  shop_id: number;
  shop: string;
  brand?: string | null;
  sku?: string | null;
  barcode?: string | null;
  unit?: string | null;
  pack_qty?: number | null;
  tags?: string[];
  sold?: number;
}

export interface BotCoupon {
  code: string;
  shop_id: number | null;
  shop: string | null;
  platform: boolean;
  discount_type: string;
  discount_value: number;
  max_discount: number | null;
  min_order_amount: number;
  expires_at: string;
}

export interface BrainPath {
  query: string;
  categories: string[];
  brands: string[];
  tags: string[];
  top_products: { no: number; product_id: number; name: string; price: number }[];
}

export type StageMode = "gallery" | "detail" | "compare" | "cart" | "coupons";

export interface BotAction {
  type: string;
  product_id?: number;
  name?: string;
  qty?: number;
  added_qty?: number;
}

export interface BotChatResponse {
  reply: string;
  engine: string;
  stage_mode: StageMode;
  parsed_hints: string[];
  products: BotProduct[];
  compare_products: BotProduct[];
  coupons: BotCoupon[];
  cart: Priced[] | null;
  actions: BotAction[];
  suggestions: string[];
  brain_path: BrainPath | null;
}

export interface BotMessage {
  id: string;
  role: "user" | "assistant";
  content: string;
  engine?: string;
  parsed_hints?: string[];
  products?: BotProduct[];
  actions?: BotAction[];
  suggestions?: string[];
  brain_path?: BrainPath | null;
}

export const TRAIT_CHIPS: readonly { id: string; label: string; icon: string }[] = [
  { id: "halal", label: "ฮาลาล", icon: "☪️" },
  { id: "no_msg", label: "ไร้ผงชูรส", icon: "🌿" },
  { id: "low_sugar", label: "น้ำตาลน้อย", icon: "🍬" },
  { id: "vegan", label: "เจ/วีแกน", icon: "🥬" },
  { id: "organic", label: "ออร์แกนิก", icon: "🌱" },
  { id: "fda", label: "มี อ.ย.", icon: "🛡️" },
  { id: "tis", label: "มอก.", icon: "🏛️" },
  { id: "warranty_1y", label: "ประกัน 1 ปี", icon: "✅" },
  { id: "wholesale", label: "แพ็กคุ้ม", icon: "📦" },
  { id: "bestseller", label: "ขายดี", icon: "🔥" },
  { id: "eco", label: "รักษ์โลก", icon: "♻️" },
  { id: "pet_safe", label: "สัตว์เลี้ยง", icon: "🐾" },
];

export const TAG_LABEL_MAP: Record<string, { label: string; icon: string }> = Object.fromEntries(
  TRAIT_CHIPS.map((t) => [t.id, { label: t.label, icon: t.icon }]),
);

const WELCOME_MSG: BotMessage = {
  id: "welcome",
  role: "assistant",
  content:
    "สวัสดีครับ! ผม **น้องเอฟดี** ผู้ช่วยค้นหาและปิดการขายของ FDE Shop 👋\nพิมพ์บอกได้เลยว่าอยากหาสินค้าอะไร งบเท่าไหร่ หรือเลือกแท็กด้านบน เช่น *\"สว่านมากิต้า งบ 3500\"*, *\"อาหารฮาลาล ไร้ผงชูรส ไม่เกิน 200\"* หรือสั่ง *\"เอาเบอร์ 1 2 ชิ้น\"* เพื่อหยิบใส่ตะกร้าทันทีครับ!",
  suggestions: [
    "อาหารฮาลาล ไร้ผงชูรส ไม่เกิน 200",
    "สว่านไร้สาย งบ 3500",
    "หูฟังไร้สาย ราคาถูกสุด",
    "มีคูปองส่วนลดอะไรบ้าง",
  ],
};

interface BotContextValue {
  messages: BotMessage[];
  busy: boolean;
  drawerOpen: boolean;
  setDrawerOpen: (v: boolean) => void;
  stageMode: StageMode;
  setStageMode: (m: StageMode) => void;
  stageProducts: BotProduct[];
  compareProducts: BotProduct[];
  setCompareProducts: (p: BotProduct[]) => void;
  toggleCompare: (p: BotProduct) => void;
  stageCoupons: BotCoupon[];
  stageCart: Priced[] | null;
  dietaryTags: string[];
  toggleDietaryTag: (tag: string) => void;
  lastEngine: string;
  brainPath: BrainPath | null;
  sendMessage: (text: string, opts?: { viewingProductId?: number; openDrawer?: boolean }) => Promise<void>;
  resetChat: () => void;
}

const Ctx = createContext<BotContextValue | null>(null);

export function BotProvider({ children }: { children: ReactNode }) {
  const qc = useQueryClient();
  const [messages, setMessages] = useState<BotMessage[]>([WELCOME_MSG]);
  const [busy, setBusy] = useState(false);
  const [drawerOpen, setDrawerOpen] = useState(false);
  const [stageMode, setStageMode] = useState<StageMode>("gallery");
  const [stageProducts, setStageProducts] = useState<BotProduct[]>([]);
  const [compareProducts, setCompareProducts] = useState<BotProduct[]>([]);
  const [stageCoupons, setStageCoupons] = useState<BotCoupon[]>([]);
  const [stageCart, setStageCart] = useState<Priced[] | null>(null);
  const [dietaryTags, setDietaryTags] = useState<string[]>([]);
  const [lastEngine, setLastEngine] = useState<string>("smart-fastpath");
  const [brainPath, setBrainPath] = useState<BrainPath | null>(null);

  const toggleDietaryTag = useCallback((tag: string) => {
    setDietaryTags((prev) => (prev.includes(tag) ? prev.filter((t) => t !== tag) : [...prev, tag]));
  }, []);

  const toggleCompare = useCallback((p: BotProduct) => {
    setCompareProducts((prev) => {
      const exists = prev.some((x) => x.product_id === p.product_id);
      if (exists) return prev.filter((x) => x.product_id !== p.product_id);
      return [...prev.slice(-3), p];
    });
  }, []);

  const resetChat = useCallback(() => {
    setMessages([WELCOME_MSG]);
    setStageMode("gallery");
    setStageProducts([]);
    setCompareProducts([]);
    setBrainPath(null);
  }, []);

  const sendMessage = useCallback(
    async (text: string, opts?: { viewingProductId?: number; openDrawer?: boolean }) => {
      const trimmed = text.trim();
      if (!trimmed || busy) return;
      if (opts?.openDrawer) setDrawerOpen(true);

      const userMsg: BotMessage = { id: `u-${Date.now()}`, role: "user", content: trimmed };
      const historyPayload = [...messages, userMsg]
        .filter((m) => m.id !== "welcome")
        .slice(-6)
        .map((m) => ({ role: m.role, content: m.content.slice(0, 480) }));

      setMessages((prev) => [...prev, userMsg]);
      setBusy(true);
      try {
        const res = await apiSend<BotChatResponse>("POST", "bot/chat", {
          message: trimmed,
          history: historyPayload,
          focus_product_ids: stageProducts.map((p) => p.product_id),
          viewing_product_id: opts?.viewingProductId ?? null,
          dietary_tags: dietaryTags,
        });
        const botMsg: BotMessage = {
          id: `a-${Date.now()}`,
          role: "assistant",
          content: res.reply,
          engine: res.engine,
          parsed_hints: res.parsed_hints,
          products: res.products,
          actions: res.actions,
          suggestions: res.suggestions,
          brain_path: res.brain_path,
        };
        setMessages((prev) => [...prev, botMsg]);
        setLastEngine(res.engine);
        setStageMode(res.stage_mode);
        if (res.products.length > 0) setStageProducts(res.products);
        if (res.compare_products.length > 0) setCompareProducts(res.compare_products);
        if (res.coupons.length > 0) setStageCoupons(res.coupons);
        if (res.cart !== null) setStageCart(res.cart);
        if (res.brain_path) setBrainPath(res.brain_path);
        if (res.actions.some((a) => a.type === "cart_added")) {
          await qc.invalidateQueries({ queryKey: ["cart"] });
        }
      } catch (e) {
        setMessages((prev) => [
          ...prev,
          { id: `e-${Date.now()}`, role: "assistant", content: `ขออภัยครับ เกิดข้อผิดพลาดในการเชื่อมต่อบอท: ${errorText(e)}` },
        ]);
      } finally {
        setBusy(false);
      }
    },
    [busy, dietaryTags, messages, qc, stageProducts],
  );

  const value = useMemo<BotContextValue>(
    () => ({
      messages,
      busy,
      drawerOpen,
      setDrawerOpen,
      stageMode,
      setStageMode,
      stageProducts,
      compareProducts,
      setCompareProducts,
      toggleCompare,
      stageCoupons,
      stageCart,
      dietaryTags,
      toggleDietaryTag,
      lastEngine,
      brainPath,
      sendMessage,
      resetChat,
    }),
    [
      messages,
      busy,
      drawerOpen,
      stageMode,
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
    ],
  );

  return <Ctx.Provider value={value}>{children}</Ctx.Provider>;
}

export function useBot() {
  const v = useContext(Ctx);
  if (!v) throw new Error("useBot must be used inside <BotProvider>");
  return v;
}

/** Lightweight inline markdown renderer for bot replies (**bold**, *italic*, `code`, newlines). */
export function BotText({ text }: { text: string }) {
  const lines = text.split("\n");
  return (
    <div className="space-y-1 text-sm leading-relaxed break-words">
      {lines.map((line, i) => {
        if (!line.trim()) return <div key={i} className="h-1" />;
        const tokens = line.split(/(\*\*[^*]+\*\*|\*[^*]+\*|`[^`]+`)/g);
        return (
          <p key={i}>
            {tokens.map((tok, j) => {
              if (tok.startsWith("**") && tok.endsWith("**")) {
                return <strong key={j} className="font-semibold text-foreground">{tok.slice(2, -2)}</strong>;
              }
              if (tok.startsWith("*") && tok.endsWith("*")) {
                return <em key={j} className="italic">{tok.slice(1, -1)}</em>;
              }
              if (tok.startsWith("`") && tok.endsWith("`")) {
                return <code key={j} className="rounded bg-muted px-1 py-0.5 font-mono text-xs">{tok.slice(1, -1)}</code>;
              }
              return <span key={j}>{tok}</span>;
            })}
          </p>
        );
      })}
    </div>
  );
}
