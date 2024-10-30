from uuid import UUID, uuid4
from sqlmodel import Field, Relationship
from schemas import TaskBase
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from .member import Member

class Task(TaskBase, table = True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)

    member_id: UUID = Field(default=None, foreign_key="member.id")
    member: "Member" = Relationship(back_populates="tasks")