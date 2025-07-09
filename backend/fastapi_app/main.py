from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
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
    server_error_handler,
)
from .logging_config import setup_logging
from .config import FRONTEND_URL
import os
import sentry_sdk
from sentry_sdk.integrations.fastapi import FastApiIntegration

setup_logging()

# Optional error tracking via Sentry
if os.getenv("SENTRY_DSN"):
    sentry_sdk.init(
        dsn=os.getenv("SENTRY_DSN"),
        integrations=[FastApiIntegration()],
        traces_sample_rate=1.0,
    )

app = FastAPI(
    title="John Galt Panel API",
    description="Backend services for John Galt Panel",
    version="0.2.0",
)


@app.get("/health", tags=["health"])
def health_check():
    return {"status": "ok"}

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=[FRONTEND_URL],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allow_headers=["*"],
)

# Rate Limiting
app.state.limiter = limiter
app.add_middleware(SlowAPIMiddleware)
app.add_exception_handler(429, _rate_limit_exceeded_handler)

# Custom Exception Handlers
app.add_exception_handler(RequestValidationError, validation_exception_handler)
app.add_exception_handler(IntegrityError, db_exception_handler)
app.add_exception_handler(HTTPException, http_exception_handler)
app.add_exception_handler(Exception, server_error_handler)  # Catch-all 500 handler

# Routers
app.include_router(api_router)
