from pydantic import BaseModel, EmailStr, Field
from app.core.roles import UserRole


class UserBase(BaseModel):
    email: EmailStr


class UserCreate(UserBase):
    password: str = Field(min_length=6, max_length=72)
    role: UserRole   # Required now


class UserResponse(UserBase):
    id: int
    role: UserRole

    class Config:
        from_attributes = True
