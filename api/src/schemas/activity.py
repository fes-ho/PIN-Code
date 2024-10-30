from typing import Optional
from sqlmodel import Field, SQLModel

class Activity(SQLModel):
    name: str
    # The value of the field is related to the unicode of the edit icon
    icon: Optional[str] = Field(default=57882)
    description: Optional[str] = Field(default="")
    duration: Optional[int] = Field(default=None)
    estimated_duration: Optional[int] = Field(default=None)