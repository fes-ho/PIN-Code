from uuid import UUID
from fastapi import APIRouter, Depends

from services import get_session
from dependencies import verify_member_id
from cruds import read_task_by_member

router = APIRouter(
    tags=["tasks"],
    dependencies=[Depends(verify_member_id)],
)

@router.get("/{member_id}/tasks")
def get_member_tasks(
    member_id: UUID, 
    db=Depends(get_session)
):
    return read_task_by_member(member_id, db)