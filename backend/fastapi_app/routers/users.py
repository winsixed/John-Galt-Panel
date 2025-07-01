from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..dependencies import get_current_user, get_db
from .. import models, schemas

router = APIRouter(prefix="/users", tags=["users"])

@router.get("/", response_model=list[schemas.UserPublic])
def list_users(db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    return db.query(models.User).all()
