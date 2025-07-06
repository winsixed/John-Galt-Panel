from fastapi import Request, status, HTTPException
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
from sqlalchemy.exc import IntegrityError
from starlette.requests import Request as StarletteRequest
import logging
import traceback


async def validation_exception_handler(request: Request, exc: RequestValidationError):
    logging.error("Validation error: %s", exc)
    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content={"detail": "Invalid input", "errors": str(exc.errors())},
    )


async def db_exception_handler(request: Request, exc: IntegrityError):
    return JSONResponse(
        status_code=status.HTTP_400_BAD_REQUEST,
        content={"detail": "Database error"},
    )


async def http_exception_handler(request: Request, exc: HTTPException):
    logging.error("HTTP error: %s", exc.detail)
    return JSONResponse(status_code=exc.status_code, content={"detail": exc.detail})


async def server_error_handler(request: StarletteRequest, exc: Exception):
    logging.error("Unhandled Exception:\n%s", traceback.format_exc())
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal Server Error"},
    )
