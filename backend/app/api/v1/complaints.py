from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload
from typing import List, Any
from app.db.database import get_db
from app.db.models.user import User
from app.db.models.complaint import Complaint, ComplaintStatusHistory
from app.schemas.complaint import ComplaintCreate, ComplaintResponse
from app.api.deps import get_current_user

router = APIRouter()

@router.post("/", response_model=ComplaintResponse)
async def create_complaint(
    complaint_in: ComplaintCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
) -> Any:
    complaint = Complaint(
        user_id=current_user.id,
        title=complaint_in.title,
        description=complaint_in.description,
        category=complaint_in.category,
        location=complaint_in.location,
        contact_details=complaint_in.contact_details,
        status="Submitted"
    )
    db.add(complaint)
    await db.commit()
    await db.refresh(complaint)

    # Add initial history record
    history = ComplaintStatusHistory(
        complaint_id=complaint.id,
        status="Submitted",
        comments="Complaint has been received and is awaiting assignment."
    )
    db.add(history)
    await db.commit()

    # Reload with history
    result = await db.execute(
        select(Complaint)
        .options(selectinload(Complaint.history))
        .where(Complaint.id == complaint.id)
    )
    return result.scalars().first()

@router.get("/", response_model=List[ComplaintResponse])
async def list_complaints(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
) -> Any:
    result = await db.execute(
        select(Complaint)
        .where(Complaint.user_id == current_user.id)
        .order_by(Complaint.created_at.desc())
    )
    return result.scalars().all()

@router.get("/{complaint_id}", response_model=ComplaintResponse)
async def get_complaint(
    complaint_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
) -> Any:
    result = await db.execute(
        select(Complaint)
        .options(selectinload(Complaint.history))
        .where(Complaint.id == complaint_id, Complaint.user_id == current_user.id)
    )
    complaint = result.scalars().first()
    if not complaint:
        raise HTTPException(status_code=404, detail="Complaint not found")
    return complaint
