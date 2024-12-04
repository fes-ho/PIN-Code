from uuid import UUID
from fastapi import APIRouter, Depends
from cruds.task import update_complete_task
from schemas import TaskCreate, TaskDurationUpdate, TaskUpdate
from services import get_session
from dependencies import verify_member_id
from cruds import read_task_by_member, create_task, update_task_duration_in_db, delete_task_in_db, update_task

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

@router.put("/tasks/{task_id}")
def put_task(
    task_id: UUID,
    taskUpdate: TaskUpdate,
    db=Depends(get_session)
):
    return update_task(task_id, taskUpdate, db)

@router.patch("/tasks/{task_id}/complete")
def patch_complete_task(
    task_id: UUID,
    db=Depends(get_session)
):
    return update_complete_task(task_id, db)

@router.delete("/tasks/{task_id}", status_code=204)
def delete_task(
    task_id: UUID,
    db=Depends(get_session)
):
    return delete_task_in_db(task_id, db)

@router.patch("/tasks/{task_id}/duration")
def update_task_duration(
    task_id: UUID,
    duration_update: TaskDurationUpdate,
    db=Depends(get_session)
):
    return update_task_duration_in_db(
        task_id, 
        duration_update.duration, 
        duration_update.estimated_duration, 
        db
    )