from fastapi import APIRouter

router = APIRouter()

@router.get("/health")
async def health():
    return {"status": "ok"}

@router.get("/health/ready")
async def health_ready():
    return {"status": "ready"}
