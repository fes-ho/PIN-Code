from uuid import UUID
from fastapi import APIRouter, Depends
from services import get_session
from dependencies import verify_member_id

router = APIRouter(
    tags=["habits"],
    dependencies=[Depends(verify_member_id)]
)

@router.get("/{member_id}/habits")
def get_member_habits(
    member_id: UUID, 
    db=Depends(get_session)
):
    return {"Hello": "World"}