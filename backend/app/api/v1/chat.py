from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import StreamingResponse
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload
from typing import List, Any
import json
import asyncio
from app.db.database import get_db
from app.db.models.user import User
from app.db.models.chat import ChatSession, ChatMessage
from app.schemas.chat import ChatSessionCreate, ChatSessionResponse, ChatMessageCreate, ChatMessageResponse
from app.api.deps import get_current_user

router = APIRouter()

@router.post("/sessions", response_model=ChatSessionResponse)
async def create_session(
    session_in: ChatSessionCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
) -> Any:
    session = ChatSession(
        user_id=current_user.id,
        title=session_in.title,
        language=session_in.language
    )
    db.add(session)
    await db.commit()
    await db.refresh(session)
    return session

@router.get("/sessions", response_model=List[ChatSessionResponse])
async def list_sessions(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
) -> Any:
    result = await db.execute(
        select(ChatSession)
        .where(ChatSession.user_id == current_user.id)
        .order_by(ChatSession.updated_at.desc())
    )
    return result.scalars().all()

@router.get("/sessions/{session_id}", response_model=ChatSessionResponse)
async def get_session(
    session_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
) -> Any:
    result = await db.execute(
        select(ChatSession)
        .options(selectinload(ChatSession.messages))
        .where(ChatSession.id == session_id, ChatSession.user_id == current_user.id)
    )
    session = result.scalars().first()
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    return session

async def mock_llm_stream(db: AsyncSession, session_id: int, user_message: str):
    # Hardcoded legal response for testing
    response_words = ("Based on general Indian law, the Bharatiya Nyaya Sanhita (BNS) "
                      "and Bharatiya Nagarik Suraksha Sanhita (BNSS) recently replaced "
                      "the IPC and CrPC. Your query requires careful legal analysis. "
                      "This is a simulated AI response confirming streaming works perfectly.").split()

    full_response = ""
    for word in response_words:
        await asyncio.sleep(0.05) # Simulate latency
        full_response += word + " "
        yield f"data: {json.dumps({'token': word + ' '})}\n\n"

    # Save assistant message to DB after streaming completes
    ai_msg = ChatMessage(
        session_id=session_id,
        role="assistant",
        content=full_response.strip(),
        language="en"
    )
    db.add(ai_msg)
    await db.commit()

    yield f"data: {json.dumps({'done': True})}\n\n"

@router.post("/sessions/{session_id}/messages/stream")
async def stream_message(
    session_id: int,
    message_in: ChatMessageCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    # Verify session
    result = await db.execute(
        select(ChatSession).where(ChatSession.id == session_id, ChatSession.user_id == current_user.id)
    )
    session = result.scalars().first()
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    # Save user message
    user_msg = ChatMessage(
        session_id=session_id,
        role="user",
        content=message_in.message,
        language=message_in.language
    )
    db.add(user_msg)
    await db.commit()

    return StreamingResponse(
        mock_llm_stream(db, session_id, message_in.message),
        media_type="text/event-stream"
    )
