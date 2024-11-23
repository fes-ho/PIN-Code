from datetime import datetime
from uuid import UUID
from sqlmodel import Field
from schemas import Activity
from pydantic import BaseModel

class TaskBase(Activity):
    date: datetime
    is_completed: bool = Field(default=False)
    member_id: UUID

class TaskCreate(TaskBase):
    pass

class TaskDurationUpdate(BaseModel):
    duration: int
    estimated_duration: int | None = None