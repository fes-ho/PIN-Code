from uuid import UUID
from fastapi import APIRouter, Depends
from schemas import TaskCreate
from services import get_session
from dependencies import verify_member_id
from cruds import read_task_by_member, create_task

router = APIRouter(
    tags=["tasks"],
)

@router.get("/members/{member_id}/tasks", dependencies=[Depends(verify_member_id)])
def get_member_tasks(
    member_id: UUID, 
    db=Depends(get_session)
):
    return read_task_by_member(member_id, db)

@router.post("/tasks", status_code=201)
def post_task(
    taskCreate: TaskCreate,
    db=Depends(get_session)
):
    verify_member_id(taskCreate.member_id, db)
    return create_task(taskCreate, db)