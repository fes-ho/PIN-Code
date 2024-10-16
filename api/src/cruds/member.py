from fastapi import Depends
from sqlmodel import Session, select
from services import get_session
from models import Member


def read_members(db: Session = Depends(get_session)):
    members = db.exec(select(Member)).all()
    return members