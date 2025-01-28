from datetime import datetime
from uuid import UUID
from sqlmodel import Field
from schemas import Activity
from pydantic import BaseModel
from .day_time import DayTime
from .frequency import Frequency
from .category import Category

class HabitBase(Activity):
    is_completed: bool = Field(default=False)
    member_id: UUID
    date: datetime
    dayTime : DayTime
    category: Category
    frequency: Frequency

class HabitCreate(HabitBase):
    pass

class HabitUpdate(HabitBase):
    pass

class HabitDurationUpdate(BaseModel):
    duration: int
    estimated_duration: int | None = None

class HabitTimeUpdate(BaseModel):
    dayTime: DayTime