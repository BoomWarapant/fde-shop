"""FDE Shop API (Workshop 2.1). Every rule lives in the database functions (supabase/migrations/); this server checks the
caller's token, validates input shapes and forwards the token. Money is never taken from the browser."""
import hmac
import os
import re
import time
import urllib.parse
from collections import defaultdict, deque
from datetime import datetime, timezone
from decimal import Decimal
from pathlib import Path
from typing import Literal

from fastapi import APIRouter, Depends, FastAPI, HTTPException, Query, Request
from fastapi.responses import HTMLResponse, JSONResponse, FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, Field

from . import supa

ROOT = Path(__file__).resolve().parents[2]
WEB_DIST = ROOT / "web" / "dist"
_prod = bool(os.environ.get("VERCEL"))
app = FastAPI(title="FDE Shop API", version="0.1.0", docs_url=None if _prod else "/docs", redoc_url=None,
              openapi_url=None if _prod else "/openapi.json")


# ---------------------------------------------------------------- who is calling
def bearer(request: Request) -> str | None:
    scheme, _, token = request.headers.get("authorization", "").partition(" ")
    return token.strip() or None if scheme.lower() == "bearer" else None


def require_user(request: Request) -> dict:
    token = bearer(request)
    if not token:
        raise HTTPException(401, "Sign in required")
    try:
        me = supa.rpc_raw("my_account", token)
    except supa.DbError as e:
        if e.status in (401, 403):
            raise HTTPException(401, "Session ended, please sign in again")
        raise HTTPException(502, "Account check failed")
    if not me:
        raise HTTPException(401, "Session ended, please sign in again")
    if me["status"] == "banned":
        raise HTTPException(403, "This account is suspended")
    request.state.token, request.state.user = token, me
    return me


def role(name: str):
    def dep(request: Request) -> dict:
        me = getattr(request.state, "user", None) or require_user(request)
        if me["role"] != name:
            raise HTTPException(403, f"This is for {name} accounts")
        return me
    return dep


# ---------------------------------------------------------------- public: catalogue, registration, health
public = APIRouter(prefix="/api")


@public.get("/catalog")
def catalog(request: Request, q: str | None = Query(None, max_length=60), category_id: int | None = Query(None, ge=1),
            shop_id: int | None = Query(None, ge=1), sort: Literal["new", "price_asc", "price_desc", "popular"] = "new",
            page: int = Query(1, ge=1), page_size: int = Query(24, ge=1, le=100)):
    out = supa.rpc(request, "catalog", {"p_q": q or None, "p_category_id": category_id, "p_shop_id": shop_id, "p_sort": sort,
                                        "p_limit": page_size, "p_offset": (page - 1) * page_size}, anonymous=True)
    return {**out, "page": page, "page_size": page_size}


@public.get("/products/{product_id}")
def product(product_id: int, request: Request):
    return supa.rpc(request, "product_page", {"p_product_id": product_id}, anonymous=True)


@public.get("/campaigns")
def campaigns(request: Request):
    return supa.rpc(request, "campaigns_live", anonymous=True)


_hits: dict[str, deque] = defaultdict(deque)


def _rate_limit(key: str, limit: int = 5, window: float = 600):
    now, q = time.monotonic(), _hits[key]
    while q and now - q[0] > window:
        q.popleft()
    if len(q) >= limit:
        raise HTTPException(429, "Too many registrations from here. Please try again later.")
    q.append(now)


class RegisterIn(BaseModel):
    email: str = Field(max_length=120, pattern=r"^[^@\s]+@[^@\s]+\.[^@\s]+$")
    password: str = Field(min_length=8, max_length=72)
    display_name: str = Field(min_length=2, max_length=60)
    role: Literal["buyer", "seller"]
    shop_name: str | None = Field(default=None, min_length=2, max_length=60)
    shop_description: str | None = Field(default=None, max_length=300)


@public.post("/register", status_code=201)
def register(body: RegisterIn, request: Request):
    """Anyone may register as buyer or seller, only through here (the database refuses any other sign-up)."""
    _rate_limit(request.headers.get("x-forwarded-for", request.client.host if request.client else "?").split(",")[0].strip())
    if body.role == "seller" and not body.shop_name:
        raise HTTPException(422, "A seller needs a shop name")
    email = body.email.strip().lower()
    # A short-lived ticket tells the database trigger this sign-up came from here, and with which role
    supa.service_rest("POST", "signup_tickets", {"email": email, "role": body.role, "created_at": datetime.now(timezone.utc).isoformat()},
                      prefer="resolution=merge-duplicates")
    try:
        user = supa.gotrue_admin("POST", "users", {
            "email": email, "password": body.password, "email_confirm": True,
            "app_metadata": {"via": "api", "role": body.role},
            "user_metadata": {"display_name": body.display_name.strip(), "shop_name": (body.shop_name or "").strip(),
                              "shop_description": (body.shop_description or "").strip()}})
    except HTTPException:
        supa.service_rest("DELETE", f"signup_tickets?email=eq.{urllib.parse.quote(email)}")
        raise
    return {"user_id": user["id"], "email": user["email"], "role": body.role}


_health: dict = {"at": 0.0, "ok": None}


@public.get("/health")
def health(request: Request):
    if _health["ok"] is None or time.monotonic() - _health["at"] > 60:
        try:
            supa.rpc(request, "campaigns_live", anonymous=True)
            _health.update(ok=True, at=time.monotonic())
        except HTTPException:
            _health.update(ok=False, at=time.monotonic())
    return JSONResponse({"ok": _health["ok"]}, status_code=200 if _health["ok"] else 503)


@public.get("/cron/expire-orders")
def cron_expire(request: Request):
    secret = os.environ.get("CRON_SECRET", "")
    if not secret or not hmac.compare_digest(request.headers.get("authorization", ""), f"Bearer {secret}"):
        raise HTTPException(401, "Cron only")
    return {"cancelled": supa.rpc_raw("cancel_expired_orders", None, {}, key=supa.service_key())}


# ---------------------------------------------------------------- signed in (any role)
user = APIRouter(prefix="/api", dependencies=[Depends(require_user)])


@user.get("/me")
def me(request: Request):
    return request.state.user


@user.get("/orders/{order_id}")
def order(order_id: int, request: Request):
    return supa.rpc(request, "order_get", {"p_order_id": order_id})


class Reason(BaseModel):
    reason: str = Field(min_length=3, max_length=500)


@user.post("/orders/{order_id}/cancel")
def cancel(order_id: int, body: Reason, request: Request):
    return supa.rpc(request, "order_cancel", {"p_order_id": order_id, "p_reason": body.reason})


@user.post("/orders/{order_id}/received")
def received(order_id: int, request: Request):
    return supa.rpc(request, "order_received", {"p_order_id": order_id})


# ---------------------------------------------------------------- buyer
buyer = APIRouter(prefix="/api", dependencies=[Depends(require_user), Depends(role("buyer"))])


@buyer.get("/cart")
def cart(request: Request):
    return supa.rpc(request, "cart_get")


class Qty(BaseModel):
    qty: int = Field(ge=0, le=99)


@buyer.put("/cart/{product_id}")
def cart_set(product_id: int, body: Qty, request: Request):
    return supa.rpc(request, "cart_set", {"p_product_id": product_id, "p_qty": body.qty})


class QuoteIn(BaseModel):
    shop_id: int = Field(ge=1)
    coupon: str | None = Field(default=None, max_length=20)


@buyer.post("/checkout/quote")
def quote(body: QuoteIn, request: Request):
    return supa.rpc(request, "checkout_quote", {"p_shop_id": body.shop_id, "p_coupon": body.coupon or None})


class CheckoutIn(QuoteIn):
    ship_name: str = Field(min_length=2, max_length=80)
    ship_phone: str = Field(pattern=r"^[0-9+\- ]{9,15}$")
    ship_address: str = Field(min_length=10, max_length=300)
    # No price, discount or total fields on purpose: the database prices the order


@buyer.post("/checkout", status_code=201)
def checkout(body: CheckoutIn, request: Request):
    return supa.rpc(request, "checkout", {"p_shop_id": body.shop_id, "p_coupon": body.coupon or None, "p_ship_name": body.ship_name,
                                          "p_ship_phone": body.ship_phone, "p_ship_address": body.ship_address})


@buyer.get("/my/orders")
def my_orders(request: Request, status: str | None = Query(None, max_length=20)):
    return supa.rpc(request, "my_orders", {"p_status": status or None})


class SlipIn(BaseModel):
    trans_ref: str = Field(min_length=6, max_length=40, pattern=r"^[A-Za-z0-9-]+$")
    amount: Decimal = Field(gt=0, max_digits=12, decimal_places=2)
    slip_path: str = Field(max_length=200)


@buyer.post("/orders/{order_id}/slip", status_code=201)
def slip(order_id: int, body: SlipIn, request: Request):
    return supa.rpc(request, "slip_submit", {"p_order_id": order_id, "p_trans_ref": body.trans_ref, "p_amount": str(body.amount),
                                             "p_slip_path": body.slip_path})


@buyer.post("/orders/{order_id}/refund", status_code=201)
def refund(order_id: int, body: Reason, request: Request):
    return supa.rpc(request, "refund_request", {"p_order_id": order_id, "p_reason": body.reason})


# ---------------------------------------------------------------- seller
seller = APIRouter(prefix="/api/seller", dependencies=[Depends(require_user), Depends(role("seller"))])


@seller.get("/overview")
def seller_overview(request: Request):
    return supa.rpc(request, "seller_overview")


@seller.get("/products")
def seller_products(request: Request):
    return supa.rpc(request, "seller_products")


class ProductIn(BaseModel):
    name: str = Field(min_length=2, max_length=120)
    description: str | None = Field(default=None, max_length=2000)
    category_id: int | None = Field(default=None, ge=1)
    price: Decimal = Field(gt=0, max_digits=12, decimal_places=2)
    image_url: str | None = Field(default=None, max_length=500)
    low_stock_threshold: int = Field(default=5, ge=0, le=100000)
    is_active: bool = True
    initial_stock: int = Field(default=0, ge=0, le=100000)


def _product_body(body: ProductIn, product_id: int | None) -> dict:
    return {"p_product_id": product_id, "p_name": body.name, "p_description": body.description, "p_category_id": body.category_id,
            "p_price": str(body.price), "p_image_url": body.image_url or None, "p_low_stock_threshold": body.low_stock_threshold,
            "p_is_active": body.is_active, "p_initial_stock": body.initial_stock}


@seller.post("/products", status_code=201)
def product_create(body: ProductIn, request: Request):
    return supa.rpc(request, "seller_product_save", _product_body(body, None))


@seller.put("/products/{product_id}")
def product_update(product_id: int, body: ProductIn, request: Request):
    return supa.rpc(request, "seller_product_save", _product_body(body, product_id))


class StockIn(BaseModel):
    change: int = Field(ge=-100000, le=100000)
    reason: Literal["RESTOCK", "ADJUST"]
    note: str | None = Field(default=None, max_length=200)


@seller.post("/products/{product_id}/stock")
def stock_adjust(product_id: int, body: StockIn, request: Request):
    return supa.rpc(request, "seller_stock_adjust", {"p_product_id": product_id, "p_change": body.change, "p_reason": body.reason,
                                                     "p_note": body.note})


@seller.get("/products/{product_id}/movements")
def movements(product_id: int, request: Request):
    return supa.rpc(request, "seller_stock_movements", {"p_product_id": product_id})


@seller.get("/orders")
def seller_orders(request: Request, status: str | None = Query(None, max_length=20)):
    return supa.rpc(request, "seller_orders", {"p_status": status or None})


class Decision(BaseModel):
    approve: bool
    note: str | None = Field(default=None, max_length=300)


@seller.post("/slips/{slip_id}/review")
def slip_review(slip_id: int, body: Decision, request: Request):
    return supa.rpc(request, "slip_review", {"p_slip_id": slip_id, "p_approve": body.approve, "p_note": body.note})


class ShipIn(BaseModel):
    carrier: str = Field(min_length=2, max_length=40)
    tracking_number: str = Field(min_length=6, max_length=30)


@seller.post("/orders/{order_id}/ship")
def ship(order_id: int, body: ShipIn, request: Request):
    return supa.rpc(request, "order_ship", {"p_order_id": order_id, "p_carrier": body.carrier, "p_tracking": body.tracking_number})


@seller.post("/refunds/{refund_id}/decision")
def refund_decide(refund_id: int, body: Decision, request: Request):
    return supa.rpc(request, "refund_decide", {"p_refund_id": refund_id, "p_approve": body.approve, "p_note": body.note})


@seller.get("/coupons")
def seller_coupons(request: Request):
    return supa.rpc(request, "seller_coupons")


class CouponIn(BaseModel):
    code: str = Field(pattern=r"^[A-Za-z0-9]{3,20}$")
    discount_type: Literal["PERCENT", "FIXED"]
    discount_value: Decimal = Field(gt=0, max_digits=12, decimal_places=2)
    max_discount: Decimal | None = Field(default=None, gt=0, max_digits=12, decimal_places=2)
    min_order_amount: Decimal = Field(default=Decimal(0), ge=0, max_digits=12, decimal_places=2)
    usage_limit_total: int | None = Field(default=None, ge=1)
    usage_limit_per_user: int = Field(default=1, ge=1, le=100)
    starts_at: datetime | None = None
    expires_at: datetime
    campaign_id: int | None = Field(default=None, ge=1)


def _coupon_body(body: CouponIn) -> dict:
    return {"p_code": body.code, "p_discount_type": body.discount_type, "p_discount_value": str(body.discount_value),
            "p_max_discount": str(body.max_discount) if body.max_discount else None, "p_min_order_amount": str(body.min_order_amount),
            "p_usage_limit_total": body.usage_limit_total, "p_usage_limit_per_user": body.usage_limit_per_user,
            "p_starts_at": body.starts_at.isoformat() if body.starts_at else None, "p_expires_at": body.expires_at.isoformat(),
            "p_campaign_id": body.campaign_id}


@seller.post("/coupons", status_code=201)
def seller_coupon_create(body: CouponIn, request: Request):
    return supa.rpc(request, "coupon_save", _coupon_body(body))


class Active(BaseModel):
    active: bool


@seller.put("/coupons/{coupon_id}/active")
def seller_coupon_active(coupon_id: int, body: Active, request: Request):
    supa.rpc(request, "coupon_set_active", {"p_coupon_id": coupon_id, "p_active": body.active})
    return {"coupon_id": coupon_id, "active": body.active}


@seller.get("/ledger")
def ledger(request: Request, date_from: str | None = Query(None, pattern=r"^\d{4}-\d{2}-\d{2}$"),
           date_to: str | None = Query(None, pattern=r"^\d{4}-\d{2}-\d{2}$")):
    return supa.rpc(request, "seller_ledger", {"p_from": date_from, "p_to": date_to})


@seller.get("/customers")
def customers(request: Request):
    return supa.rpc(request, "seller_customers")


# ---------------------------------------------------------------- platform admin
admin = APIRouter(prefix="/api/admin", dependencies=[Depends(require_user), Depends(role("admin"))])


@admin.get("/overview")
def admin_overview(request: Request, days: int = Query(30, ge=1, le=365)):
    return supa.rpc(request, "admin_overview", {"p_days": days})


@admin.get("/users")
def admin_users(request: Request, q: str | None = Query(None, max_length=60)):
    return supa.rpc(request, "admin_users", {"p_q": q or None})


class BanIn(BaseModel):
    banned: bool
    reason: str | None = Field(default=None, max_length=300)


@admin.post("/users/{user_id}/ban")
def admin_ban(user_id: str, body: BanIn, request: Request):
    if not re.fullmatch(r"[0-9a-f-]{36}", user_id):
        raise HTTPException(404, "User not found")
    out = supa.rpc(request, "admin_set_ban", {"p_user_id": user_id, "p_banned": body.banned, "p_reason": body.reason})
    # the database already refuses every action; also stop new sign-ins and token refreshes
    supa.gotrue_admin("PUT", f"users/{user_id}", {"ban_duration": "876000h" if body.banned else "none"})
    return out


@admin.get("/campaigns")
def admin_campaigns(request: Request):
    return supa.rpc(request, "admin_campaigns")


class CampaignIn(BaseModel):
    name: str = Field(min_length=3, max_length=80)
    description: str | None = Field(default=None, max_length=500)
    starts_at: datetime
    ends_at: datetime
    product_ids: list[int] = Field(default_factory=list, max_length=50)


@admin.post("/campaigns", status_code=201)
def admin_campaign_create(body: CampaignIn, request: Request):
    return supa.rpc(request, "admin_campaign_save", {"p_name": body.name, "p_description": body.description,
                                                     "p_starts_at": body.starts_at.isoformat(), "p_ends_at": body.ends_at.isoformat(),
                                                     "p_product_ids": body.product_ids})


@admin.post("/coupons", status_code=201)
def admin_coupon_create(body: CouponIn, request: Request):
    return supa.rpc(request, "coupon_save", _coupon_body(body))


@admin.put("/coupons/{coupon_id}/active")
def admin_coupon_active(coupon_id: int, body: Active, request: Request):
    supa.rpc(request, "coupon_set_active", {"p_coupon_id": coupon_id, "p_active": body.active})
    return {"coupon_id": coupon_id, "active": body.active}


for r in (public, user, buyer, seller, admin):
    app.include_router(r)


# ---------------------------------------------------------------- built frontend (production)
if WEB_DIST.exists():
    app.mount("/assets", StaticFiles(directory=WEB_DIST / "assets"), name="assets")

    @app.get("/{path:path}", include_in_schema=False)
    def spa(path: str):
        if path == "api" or path.startswith("api/"):
            raise HTTPException(404, "Not found")
        f = WEB_DIST / path
        if path and f.is_file() and WEB_DIST in f.resolve().parents and f.name != "index.html":
            return FileResponse(f)
        return HTMLResponse((WEB_DIST / "index.html").read_bytes(), headers={"Cache-Control": "no-store"})
