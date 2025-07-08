from fastapi import APIRouter, HTTPException

router = APIRouter(prefix="/health", tags=["health"])

@router.get("/", summary="Health check", description="Service health status")
def health_root():
    return {"status": "ok"}


@router.get("/error", include_in_schema=False)
def force_error():
    raise RuntimeError("test error")
