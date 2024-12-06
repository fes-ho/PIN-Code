from uuid import UUID

from fastapi import Depends
from sqlmodel import Session, select

from models.streak import Streak
from models import Task
from services import get_session


def read_streaks(member_id: UUID, db: Session = Depends(get_session)):
    tasks = db.exec(select(Task).where(Task.member_id == member_id)).all()
    streaks = []
    for task in tasks:
        if task.is_completed:
            streak = Streak(date=task.date.date())
            streaks.append(streak)
    return streaks