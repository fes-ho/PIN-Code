from __future__ import annotations
from uuid import UUID
from sqlmodel import SQLModel
from .types_of_mood import TypesOfMood
from sqlite3 import Date

class MoodBase(SQLModel):
    day: Date
    type_of_mood: TypesOfMood
    member_id: UUID