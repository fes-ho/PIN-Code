from uuid import UUID
from fastapi import Depends
from sqlmodel import Session, select
from services import get_session
from models import Task

def read_task_by_member(member_id: UUID, db: Session = Depends(get_session)):
    tasks = db.exec(select(Task).where(Task.member_id == member_id)).all()
    return tasks