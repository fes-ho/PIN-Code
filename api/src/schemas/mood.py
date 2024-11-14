from __future__ import annotations
from uuid import UUID
from sqlmodel import SQLModel
from .types_of_mood import TypeOfMood
from sqlite3 import Date

class MoodBase(SQLModel):
    day: Date
    type_of_mood: TypeOfMood
    member_id: UUID