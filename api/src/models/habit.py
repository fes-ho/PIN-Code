from uuid import UUID, uuid4
from sqlmodel import Field, Relationship
from .frequency import Frequency
from .activity import Activity
from .day_time import DayTime
from .quest import Quest
from typing import TYPE_CHECKING, List

if TYPE_CHECKING:
    from .member import Member

class Habit(Activity, table=True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    time: DayTime
    count: int

    member_id: int = Field(default=None, foreign_key="member.id")
    member: "Member" = Relationship(back_populates="habits")
    quests: List["Quest"] = Relationship(back_populates="habit")
    frequency_id: UUID = Field(foreign_key="frequency.id")
    frequency: "Frequency" = Relationship(back_populates="habit")