from typing import Optional
from uuid import UUID, uuid4
from sqlalchemy import table
from sqlmodel import Field, SQLModel

class Activity(SQLModel):
    icon: str
    name: str
    description: str
    duration: int
    estimated_duration: int