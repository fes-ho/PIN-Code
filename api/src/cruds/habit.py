from fastapi import Depends
from sqlmodel import Session, select
from models import Habit
from services import get_session

def read_habits(db: Session = Depends(get_session)):
    habits = db.exec(select(Habit)).all()
    return habits