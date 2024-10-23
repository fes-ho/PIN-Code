from uuid import UUID
from fastapi import Depends
from sqlmodel import Session, select
from services import get_session
from models import Quest, Habit

def read_quests(db: Session = Depends(get_session)):
    quests = db.exec(select(Quest)).all()
    return quests

def read_quests_by_member(member_id: UUID, db: Session = Depends(get_session)):
    habits = db.exec(select(Habit).where(Habit.member_id == member_id)).all()
    quests = []
    for habit in habits:
        habit_quests = db.exec(select(Quest).where(Quest.habit_id == habit.id)).all()
        quests.extend(habit_quests)
    return quests