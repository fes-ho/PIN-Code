from datetime import date
from typing import TYPE_CHECKING
from uuid import UUID, uuid4
from sqlmodel import Field, Relationship, SQLModel

if TYPE_CHECKING:
    from .member import Member

class Streak(SQLModel, table=True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    init_date: date
    last_modified: date
    is_finished: bool

    member_id: UUID = Field(foreign_key="member.id")
    member: "Member" = Relationship(back_populates="streaks")
