"""Calls to Supabase: database functions (as the signed-in user, anonymously, or with the service key) and the Auth admin
API (registration and bans). The service-role key is read from the server environment and never sent to the browser."""
import json
import os
import urllib.error
import urllib.request

from fastapi import HTTPException, Request


def config() -> tuple[str, str]:
    url, anon = os.environ.get("SUPABASE_URL", "").rstrip("/"), os.environ.get("SUPABASE_ANON_KEY", "")
    if not url or not anon:
        raise HTTPException(503, "Supabase is not configured (SUPABASE_URL / SUPABASE_ANON_KEY)")
    return url, anon


def service_key() -> str:
    key = os.environ.get("SUPABASE_SERVICE_ROLE_KEY", "")
    if not key:
        raise HTTPException(503, "SUPABASE_SERVICE_ROLE_KEY is not set on this server")
    return key


class DbError(Exception):
    def __init__(self, status: int, message: str):
        super().__init__(message)
        self.status, self.message = status, message


def _post(url: str, headers: dict, body: dict | None):
    req = urllib.request.Request(url, data=json.dumps(body or {}).encode(), method="POST",
                                 headers={**headers, "Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=20) as r:
            raw = r.read()
            return json.loads(raw) if raw else None
    except urllib.error.HTTPError as e:
        try:
            msg = json.loads(e.read()).get("message") or str(e.code)
        except ValueError:
            msg = str(e.code)
        raise DbError(e.code, msg)
    except urllib.error.URLError:
        raise HTTPException(503, "Database unreachable")


def rpc_raw(name: str, token: str | None, body: dict | None = None, key: str | None = None):
    url, anon = config()
    bearer = key or token or anon
    return _post(f"{url}/rest/v1/rpc/{name}", {"apikey": key or anon, "Authorization": f"Bearer {bearer}"}, body)


def rpc(request: Request | None, name: str, body: dict | None = None, *, anonymous: bool = False):
    """Run a database function as the caller (or anonymously). Database errors keep their HTTP status."""
    token = None if anonymous or request is None else getattr(request.state, "token", None)
    try:
        return rpc_raw(name, token, body)
    except DbError as e:
        raise HTTPException(e.status if e.status in (400, 401, 403, 404, 409) else 502, e.message)


def gotrue_admin(method: str, path: str, body: dict | None = None):
    url, _ = config()
    key = service_key()
    req = urllib.request.Request(f"{url}/auth/v1/admin/{path}", method=method,
                                 data=json.dumps(body).encode() if body is not None else None,
                                 headers={"apikey": key, "Authorization": f"Bearer {key}", "Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=20) as r:
            raw = r.read()
            return json.loads(raw) if raw else None
    except urllib.error.HTTPError as e:
        try:
            d = json.loads(e.read())
            msg = d.get("msg") or d.get("message") or d.get("error_description") or str(e.code)
        except ValueError:
            msg = str(e.code)
        raise HTTPException(409 if e.code == 422 and "already" in msg.lower() else (400 if e.code < 500 else 502), msg)


def service_rest(method: str, path: str, body: dict | None = None, prefer: str | None = None):
    """Table access with the service key (only for sign-up tickets: everything else goes through functions)."""
    url, _ = config()
    key = service_key()
    headers = {"apikey": key, "Authorization": f"Bearer {key}", "Content-Type": "application/json"}
    if prefer:
        headers["Prefer"] = prefer
    req = urllib.request.Request(f"{url}/rest/v1/{path}", method=method, headers=headers,
                                 data=json.dumps(body).encode() if body is not None else None)
    try:
        with urllib.request.urlopen(req, timeout=20) as r:
            return r.status
    except urllib.error.HTTPError as e:
        raise HTTPException(502, f"Sign-up ticket failed ({e.code})")
