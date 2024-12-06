from uuid import UUID
from fastapi import APIRouter, Depends

from dependencies import verify_member_id
from services import get_session
from cruds import read_streaks


router = APIRouter(
    tags=["streaks"],
)

@router.get("/members/{member_id}/streaks")
def get_streaks(
    member_id: UUID,
    db=Depends(get_session)
):
    return read_streaks(member_id, db)