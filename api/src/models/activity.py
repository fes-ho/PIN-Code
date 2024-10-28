from typing import Optional
from sqlmodel import SQLModel

class Activity(SQLModel):
    icon: Optional[str]
    name: str
    description: Optional[str]
    duration: Optional[int]
    estimated_duration: Optional[int]