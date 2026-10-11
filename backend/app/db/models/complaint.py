from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from app.db.database import Base
import uuid

class Complaint(Base):
    __tablename__ = "complaints"

    id = Column(Integer, primary_key=True, index=True)
    reference_id = Column(String, unique=True, index=True, default=lambda: f"CMP-{uuid.uuid4().hex[:8].upper()}")
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    title = Column(String, nullable=False)
    description = Column(Text, nullable=False)
    category = Column(String, nullable=False)
    location = Column(String, nullable=True)
    contact_details = Column(String, nullable=True)
    status = Column(String, default="Submitted") # Submitted, Assigned, In Progress, Resolved, Rejected
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    user = relationship("User")
    history = relationship("ComplaintStatusHistory", back_populates="complaint", cascade="all, delete-orphan")

class ComplaintStatusHistory(Base):
    __tablename__ = "complaint_status_history"

    id = Column(Integer, primary_key=True, index=True)
    complaint_id = Column(Integer, ForeignKey("complaints.id"), nullable=False)
    status = Column(String, nullable=False)
    comments = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    complaint = relationship("Complaint", back_populates="history")
