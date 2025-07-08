from fastapi import APIRouter, Depends, HTTPException, status, Request, Body
import logging
from sqlalchemy.orm import Session
from ..rate_limiter import limiter
from .. import models, schemas
from ..auth import get_password_hash, verify_password, create_access_token
from ..dependencies import get_db, get_current_user

router = APIRouter(prefix="/auth", tags=["auth"])

@router.post(
    "/register",
    response_model=schemas.UserPublic,
    status_code=201,
    summary="Register new account",
    description="Create a new user with staff role",
)
@limiter.limit("5/minute")
def register(
    request: Request,
    user_in: schemas.UserCreate,
    db: Session = Depends(get_db),
):
    existing = db.query(models.User).filter(models.User.username == user_in.username).first()
    if existing:
        raise HTTPException(status_code=400, detail="Username already registered")
    user = models.User(
        username=user_in.username,
        hashed_password=get_password_hash(user_in.password),
        role=models.UserRole.staff,
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user

@router.post(
    "/login",
    summary="Login",
    description="Obtain JWT access token",
)
@limiter.limit("5/minute")
def login(
    request: Request,
    data: schemas.UserLogin = Body(...),
    db: Session = Depends(get_db),
):
    logger = logging.getLogger("auth")
    logger.info("Login attempt user=%s", data.username)
    user = db.query(models.User).filter(models.User.username == data.username).first()
    if not user:
        logger.info("User not found: %s", data.username)
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Incorrect username or password")

    password_ok = False
    try:
        password_ok = verify_password(data.password, user.hashed_password)
    except Exception as exc:
        logger.error("Password verification failed: %s", exc)

    if not password_ok:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Incorrect username or password")

    try:
        token = create_access_token({"sub": str(user.id), "role": user.role})
    except Exception as exc:
        logger.error("Token generation failed: %s", exc)
        raise HTTPException(status_code=500, detail="Token generation failed")

    logger.info("JWT token issued for %s", user.username)
    return {"access_token": token, "token_type": "bearer"}

@router.get(
    "/me",
    response_model=schemas.UserPublic,
    summary="Get current user",
    description="Return the authenticated user's profile",
)
def read_users_me(current_user: models.User = Depends(get_current_user)):
    return current_user
