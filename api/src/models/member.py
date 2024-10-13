from uuid import UUID, uuid4
from sqlmodel import Field, SQLModel, Relationship
from .mood import Mood

class Member(SQLModel, table=True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    username: str
    password: str
    email: str
    moods: list["Mood"] = Relationship(back_populates="member")