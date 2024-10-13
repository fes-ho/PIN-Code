from uuid import UUID, uuid4
from sqlmodel import Field
from .activity import Activity
from .day_time import DayTime

class Habit(Activity, table=True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    time: DayTime
    count: int