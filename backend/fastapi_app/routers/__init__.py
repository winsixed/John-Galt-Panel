from fastapi import APIRouter
from . import auth, users

api_router = APIRouter()
api_router.include_router(auth.router, prefix="/api")
api_router.include_router(users.router, prefix="/api")
