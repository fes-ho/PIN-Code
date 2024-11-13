from uuid import UUID
from fastapi import Depends
from sqlmodel import Session, select
from schemas import MoodBase
from models import Mood
from services import get_session

def create_mood(moodBase: MoodBase, db: Session = Depends(get_session)):
    mood = Mood(**moodBase.model_dump())
    Mood.model_validate(mood)
    db.add(mood)
    db.commit()
    db.refresh(mood)
    return mood

def get_mood(id: UUID, db: Session = Depends(get_session)):
    mood = db.exec(select(Mood).where(Mood.member_id == id))
    return mood