from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime

class UserBase(BaseModel):
    email: EmailStr
    name: str
    preferred_language: str = "en"

class UserCreate(UserBase):
    password: str

class UserResponse(UserBase):
    id: int
    theme: str
    voice_enabled: bool
    notifications_enabled: bool
    is_active: bool
    is_admin: bool
    created_at: datetime

    class Config:
        from_attributes = True
