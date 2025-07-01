from pydantic import BaseModel, EmailStr
from typing import Optional
from .models import UserRole

class UserBase(BaseModel):
    email: EmailStr

class UserCreate(UserBase):
    password: str
    role: Optional[UserRole] = UserRole.staff

class UserLogin(UserBase):
    password: str

class UserPublic(UserBase):
    id: int
    role: UserRole

    class Config:
        orm_mode = True
