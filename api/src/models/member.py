from typing import List, Optional
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

    moods: Optional[List["Mood"]] = Relationship(back_populates="member")
    streaks: Optional[List["Streak"]] = Relationship(back_populates="member")
    habits: Optional[List["Habit"]] = Relationship(back_populates="member")
    tasks: Optional[List["Task"]] = Relationship(back_populates="member")