from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class ChatMessageBase(BaseModel):
    role: str
    content: str
    language: str = "en"

class ChatMessageCreate(BaseModel):
    message: str
    language: str = "en"
    mode: str = "legal"
    stream: bool = True

class ChatMessageResponse(ChatMessageBase):
    id: int
    session_id: int
    created_at: datetime

    class Config:
        from_attributes = True

class ChatSessionBase(BaseModel):
    title: str
    language: str = "en"

class ChatSessionCreate(ChatSessionBase):
    pass

class ChatSessionResponse(ChatSessionBase):
    id: int
    user_id: int
    created_at: datetime
    updated_at: Optional[datetime] = None
    messages: Optional[List[ChatMessageResponse]] = []

    class Config:
        from_attributes = True
