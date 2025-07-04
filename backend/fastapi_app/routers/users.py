from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from passlib.context import CryptContext

from ..dependencies import get_current_user, get_db, requires_role
from .. import models, schemas
from ..models import UserRole
from ..schemas import UserCreate, UserPublic

router = APIRouter(prefix="/users", tags=["users"])

@router.get("/", response_model=list[UserPublic])
def list_users(db: Session = Depends(get_db), current_user: models.User = requires_role(UserRole.admin)):
    return db.query(models.User).all()

@router.get("/admin-only")
def admin_info(current_user: models.User = requires_role(UserRole.admin)):
    return {"message": "secret"}

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

@router.post("/create", response_model=UserPublic)
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    existing = db.query(models.User).filter_by(username=user.username).first()
    if existing:
        raise HTTPException(status_code=400, detail="User already exists")

    hashed_pw = pwd_context.hash(user.password)
    new_user = models.User(
        username=user.username,
        hashed_password=hashed_pw,
        role=user.role
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user
