from sqlite3 import Date
from uuid import UUID
from fastapi import Depends
from sqlmodel import Session, select
from schemas import MoodBase, TypeOfMood
from models import Mood
from services import get_session

def create_mood(moodBase: MoodBase, db: Session = Depends(get_session)):
    mood = Mood(**moodBase.model_dump())
    Mood.model_validate(mood)
    db.add(mood)
    db.commit()
    db.refresh(mood)
    return mood

def get_mood(id: UUID, date: Date, db: Session = Depends(get_session)):
    mood = db.exec(select(Mood).where(Mood.member_id == id and Mood.day == date)).first()
    return mood

def delete_mood(mood: Mood, db: Session = Depends(get_session)):
    db.delete(mood)
    db.commit()
    return True

def update_mood(mood_id: UUID, type_of_mood: TypeOfMood, db : Session = Depends(get_session)):
    mood = db.exec(select(Mood).where(Mood.id == mood_id)).one()
    mood.type_of_mood = type_of_mood
    db.add(mood)
    db.commit()
    db.refresh(mood)
    return mood