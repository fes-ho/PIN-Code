from typing import Optional
from uuid import UUID
from sqlmodel import Field, SQLModel

class Friendship(SQLModel, table=True):
    member_id: Optional[UUID] = Field(default=None, foreign_key="member.id", primary_key=True)
    friend_id: Optional[UUID] = Field(default=None, foreign_key="member.id", primary_key=True)