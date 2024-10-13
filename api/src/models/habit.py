from uuid import UUID, uuid4
from sqlmodel import Field, Relationship
from .activity import Activity
from .day_time import DayTime
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from .member import Member

class Habit(Activity, table=True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    time: DayTime
    count: int

    member_id: int = Field(default=None, foreign_key="member.id")
    member: "Member" = Relationship(back_populates="habits")