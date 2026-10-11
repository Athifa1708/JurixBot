from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class ComplaintHistoryResponse(BaseModel):
    id: int
    status: str
    comments: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True

class ComplaintBase(BaseModel):
    title: str
    description: str
    category: str
    location: Optional[str] = None
    contact_details: Optional[str] = None

class ComplaintCreate(ComplaintBase):
    pass

class ComplaintResponse(ComplaintBase):
    id: int
    reference_id: str
    status: str
    created_at: datetime
    updated_at: Optional[datetime] = None
    history: List[ComplaintHistoryResponse] = []

    class Config:
        from_attributes = True
