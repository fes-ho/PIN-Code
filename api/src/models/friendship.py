from typing import Optional
from sqlmodel import Field, SQLModel

class Friendship(SQLModel, table=True):
    member_id: Optional[int] = Field(default=None, foreign_key="member.id", primary_key=True)
    friend_id: Optional[int] = Field(default=None, foreign_key="member.id", primary_key=True)