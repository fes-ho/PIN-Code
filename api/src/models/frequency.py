from uuid import UUID, uuid4
from sqlalchemy import JSON, Column
from sqlmodel import Field, Relationship, SQLModel
from .days_of_the_week import DaysOfTheWeek
from typing import TYPE_CHECKING, Optional, Set
from pydantic.functional_validators import field_validator

if TYPE_CHECKING:
    from .habit import Habit

class Frequency (SQLModel, table=True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)

    # This is needed because SQLModel does not support inheritance
    daily: bool = Field(default=False)
    days_of_the_week: Optional[Set[DaysOfTheWeek]] = Field(default_factory=set, sa_column=Column(JSON))
    days_of_the_month: Optional[Set[int]] =  Field(default_factory=set, sa_column=Column(JSON))

    habit_id: UUID = Field(foreign_key="habit.id")
    habit: "Habit" = Relationship(back_populates="frequency")
    
    ## Validator for days_of_the_week
    #@field_validator("days_of_the_week", pre=True)
    #def check_days_of_the_week(cls, v, values: FieldValidationInfo):
    #    if values.data.get("daily") and v:
    #        raise ValueError("Cannot specify both 'daily' and 'days_of_the_week'.")
    #    return v
#
    ## Validator for days_of_the_month
    #@field_validator("days_of_the_month", pre=True)
    #def check_days_of_the_month(cls, v, values: FieldValidationInfo):
    #    if values.data.get("daily") and v:
    #        raise ValueError("Cannot specify both 'daily' and 'days_of_the_month'.")
    #    # Ensure all days of the month are between 1 and 31
    #    if any(day < 1 or day > 31 for day in v):
    #        raise ValueError("All days_of_the_month must be between 1 and 31.")
    #    return v
#
    ## Validator to ensure both days_of_the_week and days_of_the_month aren't specified together
    #@field_validator("days_of_the_week", "days_of_the_month", pre=True)
    #def check_week_and_month(cls, v, values: FieldValidationInfo, field):
    #    if field.name == "days_of_the_week" and values.data.get("days_of_the_month"):
    #        raise ValueError("Cannot specify both 'days_of_the_week' and 'days_of_the_month'.")
    #    if field.name == "days_of_the_month" and values.data.get("days_of_the_week"):
    #        raise ValueError("Cannot specify both 'days_of_the_month' and 'days_of_the_week'.")
    #    return v
    #    