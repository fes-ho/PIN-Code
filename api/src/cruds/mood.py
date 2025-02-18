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

def delete_mood(mood_id: UUID, db: Session = Depends(get_session)):
    mood = get_mood_by_id(mood_id, db)
    db.delete(mood)
    db.commit()
    return True

def update_mood(mood_id: UUID, type_of_mood: TypeOfMood, db : Session = Depends(get_session)):
    mood = get_mood_by_id(mood_id, db)
    mood.type_of_mood = type_of_mood
    db.add(mood)
    db.commit()
    db.refresh(mood)
    return mood

def get_member_moods(member_id: UUID, db: Session = Depends(get_session)):
    moods = db.exec(select(Mood).where(Mood.member_id == member_id)).all()
    return moods

def get_mood_by_id(id: UUID, db: Session = Depends(get_session)):
    return db.exec(select(Mood).where(Mood.id == id)).one()