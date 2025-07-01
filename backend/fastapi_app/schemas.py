from pydantic import BaseModel, EmailStr
from typing import Optional

class UserBase(BaseModel):
    email: EmailStr

class UserCreate(UserBase):
    password: str
    role: Optional[str] = 'employee'

class UserLogin(UserBase):
    password: str

class UserPublic(UserBase):
    id: int
    role: str

    class Config:
        orm_mode = True
