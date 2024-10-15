from datetime import datetime
from uuid import UUID, uuid4
from sqlmodel import Field, Relationship
from .activity import Activity
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from .member import Member

class Task(Activity, table = True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    date: datetime
    is_completed: bool = Field(default=False)

    member_id: UUID = Field(default=None, foreign_key="member.id")
    member: "Member" = Relationship(back_populates="tasks")