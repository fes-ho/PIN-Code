from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException
from services import get_session

router = APIRouter(
    tags=["habits"],
)

@router.get("/{member_id}/habits")
def get_member_habits(
    member_id: UUID, 
    db=Depends(get_session)
):
    return {"Hello": "World"}