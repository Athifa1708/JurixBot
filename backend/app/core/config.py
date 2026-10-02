import os
from typing import List
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    PROJECT_NAME: str = "JuriXBot"
    API_V1_STR: str = "/api/v1"

    DATABASE_URL: str = "sqlite+aiosqlite:///./jurixbot.db"
    REDIS_URL: str = "redis://localhost:6379/0"

    JWT_SECRET: str = "supersecret_jwt_key_please_change"
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7

    LLM_PROVIDER: str = "openai"
    LLM_API_KEY: str = ""

    EMBEDDING_PROVIDER: str = "openai"
    EMBEDDING_API_KEY: str = ""

    VECTOR_DB_URL: str = "http://localhost:6333"
    VECTOR_DB_API_KEY: str = ""

    STORAGE_PATH: str = "./storage"
    MAX_FILE_SIZE: int = 10485760
    CORS_ORIGINS: List[str] = ["*"]

    class Config:
        env_file = ".env"
        case_sensitive = True

settings = Settings()
