from fastapi import APIRouter

router = APIRouter(
    tags=["health"]
)

@router.get("/health")
def read_health():
    return {"message": "Healthy!"}