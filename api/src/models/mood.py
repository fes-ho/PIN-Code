from re import T
from sqlite3 import Date
from typing import TYPE_CHECKING
from uuid import UUID, uuid4
from sqlmodel import Field, Relationship, SQLModel
from .types_of_mood import TypesOfMood

if TYPE_CHECKING:
    from .member import Member

class Mood(SQLModel, table=True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    day: Date
    type_of_mood: TypesOfMood
    member_id: UUID = Field(foreign_key="member.id")
    member: "Member" = Relationship(back_populates="moods")