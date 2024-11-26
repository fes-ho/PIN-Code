from __future__ import annotations
from uuid import UUID
from sqlmodel import SQLModel
from .type_of_mood import TypeOfMood
from datetime import datetime

class MoodBase(SQLModel):
    day: datetime
    type_of_mood: TypeOfMood
    member_id: UUID