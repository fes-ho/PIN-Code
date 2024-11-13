from uuid import UUID
from sqlalchemy import Date
from sqlmodel import SQLModel
from models import TypesOfMood

class MoodBase(SQLModel):
    day: Date
    type_of_mood: TypesOfMood
    member_id: UUID