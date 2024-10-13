from uuid import UUID, uuid4
from sqlite3 import Date

from sqlmodel import Field

from .activity import Activity

class Task(Activity, table = True):
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    date: Date
    is_completed: bool