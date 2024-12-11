from uuid import UUID
from sqlmodel import Field
from schemas import Activity
from pydantic import BaseModel
from models import DayTime

class HabitBase(Activity):
    is_completed: bool = Field(default=False)
    member_id: UUID

class HabitCreate(HabitBase):
    pass

class HabitUpdate(HabitBase):
    pass

class HabitDurationUpdate(BaseModel):
    duration: int
    estimated_duration: int | None = None

class HabitTimeUpdate(BaseModel):
    dayTime: DayTime