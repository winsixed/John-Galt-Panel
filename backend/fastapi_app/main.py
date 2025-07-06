from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI
from fastapi.exceptions import RequestValidationError, HTTPException
from sqlalchemy.exc import IntegrityError
from slowapi import _rate_limit_exceeded_handler
from slowapi.middleware import SlowAPIMiddleware
from .routers import api_router
from .rate_limiter import limiter
from .exception_handlers import (
    validation_exception_handler,
    db_exception_handler,
    http_exception_handler,
)
from .logging_config import setup_logging
import os
import sentry_sdk

setup_logging()
if os.getenv("SENTRY_DSN"):
    sentry_sdk.init(dsn=os.getenv("SENTRY_DSN"))


app = FastAPI(
    title="John Galt Panel API",
    description="Backend services for John Galt Panel",
    version="0.2.0",
)
app.state.limiter = limiter
app.add_exception_handler(HTTPException, http_exception_handler)
app.add_exception_handler(429, _rate_limit_exceeded_handler)
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])
app.add_middleware(SlowAPIMiddleware)

app.add_exception_handler(RequestValidationError, validation_exception_handler)
app.add_exception_handler(IntegrityError, db_exception_handler)

app.include_router(api_router)


