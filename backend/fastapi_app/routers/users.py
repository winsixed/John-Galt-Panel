from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..dependencies import get_current_user, get_db, requires_role
from .. import models, schemas
from ..models import UserRole

router = APIRouter(prefix="/users", tags=["users"])

@router.get("/", response_model=list[schemas.UserPublic])
def list_users(db: Session = Depends(get_db), current_user: models.User = requires_role(UserRole.admin)):
    return db.query(models.User).all()


@router.get("/admin-only")
def admin_info(current_user: models.User = requires_role(UserRole.admin)):
    return {"message": "secret"}
