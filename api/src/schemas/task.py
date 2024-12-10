from datetime import datetime
from uuid import UUID
from sqlmodel import Field
from schemas import Activity
from pydantic import BaseModel, field_validator

class TaskBase(Activity):
    date: datetime
    is_completed: bool = Field(default=False)
    member_id: UUID
    priority: int = Field(default=3)  # Default priority is 3 (medium)

    @field_validator('priority')
    @classmethod
    def validate_priority(cls, v: int) -> int:
        if not 1 <= v <= 5:
            raise ValueError('Priority must be between 1 and 5')
        return v

class TaskCreate(TaskBase):
    pass

class TaskUpdate(TaskBase):
    pass

class TaskDurationUpdate(BaseModel):
    duration: int
    estimated_duration: int | None = None