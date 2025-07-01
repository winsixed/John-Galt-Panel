import enum
from sqlalchemy import Column, Integer, String, Enum
from .database import Base


class UserRole(str, enum.Enum):
    admin = "admin"
    staff = "staff"
    viewer = "viewer"

class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    role = Column(Enum(UserRole), default=UserRole.staff, nullable=False)
