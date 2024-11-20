from uuid import UUID
from fastapi import Depends
from sqlmodel import Session, select
from services import get_session
from models import Task
from schemas import TaskCreate

def read_task_by_member(member_id: UUID, db: Session = Depends(get_session)):
    tasks = db.exec(select(Task).where(Task.member_id == member_id)).all()
    return tasks

def create_task(taskCreate: TaskCreate, db: Session = Depends(get_session)):
    task: Task = Task(**taskCreate.model_dump())
    Task.model_validate(task)
    db.add(task)
    db.commit()
    db.refresh(task)
    return task