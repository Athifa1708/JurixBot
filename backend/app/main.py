from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from sqlalchemy import select
from app.core.config import settings
from app.core.security import get_password_hash
from app.db.database import get_db, AsyncSessionLocal, engine, Base
from app.db.models.user import User
# Import models to ensure they are registered with Base metadata
from app.db.models.chat import ChatSession, ChatMessage
from app.api.v1 import health, auth, chat

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Auto-create tables if Alembic hasn't been run (Good for local dev resilience)
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    # Seed the database with test user
    async with AsyncSessionLocal() as db:
        result = await db.execute(select(User).where(User.email == "a@gmail.com"))
        user = result.scalars().first()
        if not user:
            print("Seeding test user a@gmail.com...")
            test_user = User(
                email="a@gmail.com",
                name="Test User",
                password_hash=get_password_hash("12345"),
                is_active=True
            )
            db.add(test_user)
            await db.commit()
    yield

app = FastAPI(
    title=settings.PROJECT_NAME,
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
    lifespan=lifespan
)

if settings.CORS_ORIGINS:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.CORS_ORIGINS,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

app.include_router(health.router, tags=["health"])
app.include_router(auth.router, prefix=f"{settings.API_V1_STR}/auth", tags=["auth"])
app.include_router(chat.router, prefix=f"{settings.API_V1_STR}/chat", tags=["chat"])
