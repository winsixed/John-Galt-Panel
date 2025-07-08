from fastapi import APIRouter, Depends, HTTPException, Request
from ..rate_limiter import limiter
from sqlalchemy.orm import Session
from ..dependencies import get_current_user, get_db, requires_role
from ..auth import get_password_hash
from .. import models, schemas
from ..models import UserRole
from ..schemas import UserCreate, UserPublic

router = APIRouter(prefix="/users", tags=["users"])

@router.get(
    "/",
    response_model=list[UserPublic],
    summary="List users",
    description="Retrieve all registered users",
)
def list_users(db: Session = Depends(get_db), current_user: models.User = requires_role(UserRole.admin)):
    return db.query(models.User).all()

@router.get(
    "/admin-only",
    summary="Admin secret",
    description="Endpoint visible only to admins",
)
def admin_info(current_user: models.User = requires_role(UserRole.admin)):
    return {"message": "secret"}


@router.get("/staff", summary="Staff area")
def staff_area(current_user: models.User = requires_role(UserRole.staff, UserRole.admin)):
    return {"message": "hello staff"}


@router.get("/viewer", summary="Viewer area")
def viewer_area(current_user: models.User = requires_role(UserRole.viewer)):
    return {"message": "hello viewer"}


@router.get("/inventory", summary="Inventory manager area")
def inventory_area(current_user: models.User = requires_role(UserRole.inventory)):
    return {"message": "inventory"}

@router.post(
    "/create",
    response_model=UserPublic,
    summary="Create user",
    description="Admin creates a new user",
)
@limiter.limit("10/minute")
def create_user(
    request: Request,
    user: UserCreate,
    db: Session = Depends(get_db),
    current_user: models.User = requires_role(UserRole.admin),
):
    existing = db.query(models.User).filter_by(username=user.username).first()
    if existing:
        raise HTTPException(status_code=400, detail="User already exists")

    hashed_pw = get_password_hash(user.password)
    new_user = models.User(
        username=user.username,
        hashed_password=hashed_pw,
        role=user.role,
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user
