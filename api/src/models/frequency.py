from uuid import UUID, uuid4
from sqlalchemy import JSON, Column
from sqlmodel import Field, Relationship, SQLModel
from .days_of_the_week import DaysOfTheWeek
from typing import TYPE_CHECKING, Optional, Set

if TYPE_CHECKING:
    from .habit import Habit

class Frequency (SQLModel, table=True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    daily: bool = Field(default=False)
    days_of_the_week: Optional[Set[DaysOfTheWeek]] = Field(default_factory=set, sa_column=Column(JSON))
    days_of_the_month: Optional[Set[int]] =  Field(default_factory=set, sa_column=Column(JSON))

    habit_id: UUID = Field(foreign_key="habit.id")
    habit: "Habit" = Relationship(back_populates="frequency")