from fastapi import APIRouter

router = APIRouter()

@router.get("/members")
def get_members():
    return {"Hello": "World"}
