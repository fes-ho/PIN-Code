from sqlite3 import Date
from uuid import UUID, uuid4
from sqlmodel import Field, Relationship, SQLModel
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from .habit import Habit


class Quest(SQLModel, table=True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    date: Date
    isCompleted: bool = Field(default=False)
    currentCount: int

    habit_id: UUID = Field(foreign_key="habit.id")
    habit: "Habit" = Relationship(back_populates="quests")
