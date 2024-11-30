from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, Security
from schemas import TaskCreate, TaskDurationUpdate
from services import get_session
from dependencies import verify_member_id
from cruds import read_task_by_member, create_task, update_task_duration_in_db
from models import Task
from fastapi.security import HTTPBearer

security = HTTPBearer()

router = APIRouter(
    tags=["tasks"],
    dependencies=[Depends(security)]
)

@router.get(
    "/members/{member_id}/tasks",
    dependencies=[Depends(verify_member_id)],
    response_model=list[Task],
    summary="Get Member Tasks",
    description="Retrieves all tasks associated with a specific member ID"
)
def get_member_tasks(
    member_id: UUID, 
    db=Depends(get_session)
):
    """
    Get all tasks for a specific member.

    Parameters:
    - **member_id**: UUID of the member
    
    Returns:
    - List of tasks belonging to the member
    """
    return read_task_by_member(member_id, db)

@router.post(
    "/tasks", 
    status_code=201,
    response_model=Task,
    summary="Create Task",
    description="Creates a new task for a member"
)
def post_task(
    taskCreate: TaskCreate,
    db=Depends(get_session)
):
    """
    Create a new task.

    Parameters:
    - **taskCreate**: Task creation data including member_id
    
    Returns:
    - Created task object
    """
    verify_member_id(taskCreate.member_id, db)
    return create_task(taskCreate, db)

@router.patch(
    "/tasks/{task_id}/duration",
    response_model=Task,
    summary="Update Task Duration",
    description="Updates the duration and optionally the estimated duration of a task"
)
def update_task_duration(
    task_id: UUID,
    duration_update: TaskDurationUpdate,
    db=Depends(get_session)
):
    """
    Update task duration and estimated duration.

    Parameters:
    - **task_id**: UUID of the task to update
    - **duration_update**: Object containing duration and optional estimated_duration
    
    Returns:
    - Updated task object
    
    Raises:
    - 404: Task not found
    """
    return update_task_duration_in_db(
        task_id, 
        duration_update.duration, 
        duration_update.estimated_duration, 
        db
    )