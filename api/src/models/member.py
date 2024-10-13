from typing import Optional
from uuid import UUID, uuid4
from sqlmodel import Field, SQLModel

class Member(SQLModel, table=True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    username: str
    password: str
    email: str