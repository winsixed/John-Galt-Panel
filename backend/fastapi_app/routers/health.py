from fastapi import APIRouter, HTTPException

router = APIRouter(prefix="/health", tags=["health"])

@router.get("/", summary="Health check", description="Service health status")
def health_root():
    """Simple health check endpoint for uptime monitoring."""
    return {"status": "healthy"}


@router.get("/error", include_in_schema=False)
def force_error():
    raise RuntimeError("test error")
