from fastapi import APIRouter, Depends, HTTPException, status, Request
from sqlalchemy.orm import Session
from ..rate_limiter import limiter
from .. import models, schemas
from ..auth import get_password_hash, verify_password, create_access_token
from ..dependencies import get_db

router = APIRouter(prefix="/auth", tags=["auth"])

@router.post(
    "/register",
    response_model=schemas.UserPublic,
    status_code=201,
    summary="Register new account",
    description="Create a new user with staff role",
)
def register(user_in: schemas.UserCreate, db: Session = Depends(get_db)):
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
    data: schemas.UserLogin,
    db: Session = Depends(get_db),
):
    user = db.query(models.User).filter(models.User.username == data.username).first()
    if not user or not verify_password(data.password, user.hashed_password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Incorrect username or password")
    token = create_access_token({"sub": user.username, "role": user.role})
    return {"access_token": token, "token_type": "bearer"}
from ..dependencies import get_current_user

@router.get(
    "/me",
    response_model=schemas.UserPublic,
    summary="Get current user",
    description="Return the authenticated user's profile",
)
def read_users_me(current_user: models.User = Depends(get_current_user)):
    return current_user
