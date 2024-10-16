from uuid import UUID
from fastapi import APIRouter, Depends

from api.src.services.database import get_session

router = APIRouter(
    tags=["moods"],
)

@router.get("/{member_id}/moods")
def get_member_moods(
    member_id: UUID, 
    db=Depends(get_session)
):
    return {"Hello": "World"}