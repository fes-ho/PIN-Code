from datetime import date
from typing import TYPE_CHECKING
from uuid import UUID, uuid4
from pydantic import BaseModel
from sqlmodel import Field, Relationship, SQLModel

if TYPE_CHECKING:
    from .member import Member

class Streak(SQLModel, table = False):
    date: date