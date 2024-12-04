from uuid import UUID
from fastapi import Depends, HTTPException
from sqlmodel import Session, select
from services import get_session
from models import Task
from schemas import TaskCreate, TaskUpdate

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

def update_complete_task(task_id: UUID, db: Session = Depends(get_session)):
    task = db.get(Task, task_id)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    task.is_completed = not task.is_completed
    db.add(task)
    db.commit()
    db.refresh(task)

def update_task(task_id: UUID, taskUpdate: TaskUpdate, db: Session = Depends(get_session)):
    task = db.get(Task, task_id)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    update_data = taskUpdate.model_dump()
    for key, value in update_data.items():
        setattr(task, key, value)
    Task.model_validate(update_data)

    db.add(task)
    db.commit()
    db.refresh(task)

    return task

def delete_task_in_db(task_id: UUID, db: Session = Depends(get_session)):
    task = db.get(Task, task_id)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    db.delete(task)
    db.commit()
    return {"message": "Task deleted"}