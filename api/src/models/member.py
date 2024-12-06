from typing import List, Optional
from uuid import UUID, uuid4
from sqlmodel import Field, Relationship
from .streak import Streak
from .mood import Mood
from .habit import Habit
from .task import Task
from schemas import MemberBase

class Member(MemberBase, table=True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)

    moods: Optional[List["Mood"]] = Relationship(back_populates="member")
    habits: Optional[List["Habit"]] = Relationship(back_populates="member")
    tasks: Optional[List["Task"]] = Relationship(back_populates="member")
    friends: Optional[List["Member"]] = Relationship(
        sa_relationship_kwargs = {
            "secondary": "friendship",
            "primaryjoin": "Member.id==Friendship.member_id",
            "secondaryjoin": "Member.id==Friendship.friend_id",
            "back_populates": "friends",
        }
    )