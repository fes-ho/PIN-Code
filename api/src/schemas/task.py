from datetime import datetime
from uuid import UUID
from sqlmodel import Field
from schemas import Activity

class TaskBase(Activity):
    date: datetime
    is_completed: bool = Field(default=False)
    member_id: UUID

class TaskCreate(TaskBase):
    pass