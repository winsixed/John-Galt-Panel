from fastapi import Depends, HTTPException, status
from jose import JWTError, jwt
from sqlalchemy.orm import Session
from fastapi.security import OAuth2PasswordBearer
from .database import SessionLocal
from .auth import SECRET_KEY, ALGORITHM, JWT_AUDIENCE, JWT_ISSUER
from . import models
from .models import UserRole

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(
            token,
            SECRET_KEY,
            algorithms=[ALGORITHM],
            audience=JWT_AUDIENCE,
            issuer=JWT_ISSUER,
        )
        if not payload.get("scope"):
            raise credentials_exception
        sub = payload.get("sub")
        if sub is None:
            raise credentials_exception
        try:
            user_id = int(sub)
        except ValueError:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if user is None:
        raise credentials_exception
    return user


def requires_role(*allowed_roles: UserRole):
    def wrapper(user: models.User = Depends(get_current_user)):
        if user.role not in allowed_roles:
            raise HTTPException(status_code=403, detail="Недостаточно прав")
        return user

    return Depends(wrapper)
