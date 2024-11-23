from uuid import UUID
from fastapi import Depends, HTTPException
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

def update_task_duration_in_db(
    task_id: UUID, 
    duration: int, 
    estimated_duration: int | None = None,
    db: Session = Depends(get_session)
) -> Task:
    task = db.get(Task, task_id)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    
    task.duration = duration
    if estimated_duration is not None:
        task.estimated_duration = estimated_duration
    
    db.add(task)
    db.commit()
    db.refresh(task)
    return task