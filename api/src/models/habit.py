from uuid import UUID, uuid4
from sqlmodel import Field, Relationship
from .frequency import Frequency
from schemas import HabitBase
from .quest import Quest
from typing import TYPE_CHECKING, List

if TYPE_CHECKING:
    from .member import Member

class Habit(HabitBase, table=True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    count: int

    member_id: UUID = Field(foreign_key="member.id")
    member: "Member" = Relationship(back_populates="habits")

    quests: List[Quest] = Relationship(back_populates="habit")

    frequency: Frequency = Relationship(back_populates="habit")