from typing import TYPE_CHECKING
from uuid import UUID, uuid4
from sqlmodel import Field, Relationship
from schemas import MoodBase

if TYPE_CHECKING:
    from .member import Member

class Mood(MoodBase, table=True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    
    member_id: UUID = Field(foreign_key="member.id")
    member: "Member" = Relationship(back_populates="moods")