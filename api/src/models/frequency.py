from uuid import UUID, uuid4
from pydantic import model_validator
from sqlalchemy import JSON, Column
from sqlmodel import Field, Relationship, SQLModel
from .days_of_the_week import DaysOfTheWeek
from typing import TYPE_CHECKING, List, Optional, Self

if TYPE_CHECKING:
    from .habit import Habit

class Frequency (SQLModel, table=True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)

    # This is needed because SQLModel does not support inheritance
    daily: bool = Field(default=False)
    days_of_the_week: Optional[List[DaysOfTheWeek]] = Field(default_factory=list, sa_column=Column(JSON))
    days_of_the_month: Optional[List[int]] =  Field(default_factory=list, sa_column=Column(JSON))

    habit_id: UUID = Field(foreign_key="habit.id")
    
    @model_validator(mode="after")
    def check_daily_and_days_of_the_week(self) -> Self:
        if self.daily and self.days_of_the_week != []:
            raise ValueError("Cannot specify both 'daily' and 'days_of_the_week'.")
        return self

    @model_validator(mode="after")
    def check_daily_and_days_of_the_month(self) -> Self:
        if self.daily and self.days_of_the_month != []:
            raise ValueError("Cannot specify both 'daily' and 'days_of_the_month'.")
        return self

    @model_validator(mode="after")
    def check_days_of_the_month(self) -> Self:
        if self.days_of_the_month and any(day < 1 or day > 31 for day in self.days_of_the_month):
            raise ValueError("The 'days_of_the_month' must be between 1 and 31.")
        return self