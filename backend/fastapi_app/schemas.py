from pydantic import BaseModel, Field
from typing import Optional
from .models import UserRole

username_regex = r"^[a-zA-Z0-9_]+$"


class UserBase(BaseModel):
    username: str = Field(..., min_length=3, max_length=50, pattern=username_regex)

class UserCreate(UserBase):
    password: str = Field(..., min_length=6)
    role: Optional[UserRole] = UserRole.staff

class UserLogin(UserBase):
    password: str = Field(..., min_length=6)

class UserPublic(UserBase):
    id: int
    role: UserRole

    class Config:
        orm_mode = True
