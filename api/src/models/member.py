from typing import TYPE_CHECKING, List
from uuid import UUID, uuid4
from sqlmodel import Field, Relationship, SQLModel
from .streak import Streak
from .mood import Mood
from .habit import Habit
from .task import Task

class Member(SQLModel, table=True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    username: str
    password: str
    email: str

    moods: List["Mood"] = Relationship(back_populates="member")
    streaks: List["Streak"] = Relationship(back_populates="member")
    habits: List["Habit"] = Relationship(back_populates="member")
    tasks: List["Task"] = Relationship(back_populates="member")