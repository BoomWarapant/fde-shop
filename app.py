"""Vercel entrypoint: exposes the FastAPI app from src/shop_api (API + built web/dist in one function)."""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent / "src"))

from shop_api.app import app  # noqa: E402,F401
