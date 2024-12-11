from uuid import UUID
from fastapi import Depends, HTTPException
from sqlmodel import Session, select
from models import Habit
from services import get_session
from schemas import HabitCreate, HabitUpdate, DayTime

def read_habits(db: Session = Depends(get_session)):
    habits = db.exec(select(Habit)).all()
    return habits

def read_habits_by_member(member_id: int, db: Session = Depends(get_session)):
    habits = db.exec(select(Habit).where(Habit.member_id == member_id)).all()
    return habits

def create_habit(habitCreate: HabitCreate, db: Session = Depends(get_session)):
    habit: Habit = Habit(**habitCreate.model_dump())
    Habit.model_validate(habit)
    db.add(habit)
    db.commit()
    db.refresh(habit)
    return habit

def update_habit_duration_in_db(
    habit_id: UUID, 
    duration: int, 
    estimated_duration: int | None = None,
    db: Session = Depends(get_session)
) -> Habit:
    habit = db.get(Habit, habit_id)
    if not habit:
        raise HTTPException(status_code=404, detail="Habit not found")
    
    habit.duration = duration
    if estimated_duration is not None:
        habit.estimated_duration = estimated_duration
    
    db.add(habit)
    db.commit()
    db.refresh(habit)
    return habit

def update_habit_time_in_db(
    habit_id: UUID, 
    dayTime: DayTime, 
    db: Session = Depends(get_session)
) -> Habit:
    habit = db.get(Habit, habit_id)
    if not habit:
        raise HTTPException(status_code=404, detail="Habit not found")
    
    habit.time = dayTime
    
    db.add(habit)
    db.commit()
    db.refresh(habit)
    return habit

def update_complete_habit(habit_id: UUID, db: Session = Depends(get_session)):
    habit = db.get(Habit, habit_id)
    if not habit:
        raise HTTPException(status_code=404, detail="Habit not found")
    habit.is_completed = not habit.is_completed
    db.add(habit)
    db.commit()
    db.refresh(habit)

def update_habit(habit_id: UUID, habitUpdate: HabitUpdate, db: Session = Depends(get_session)):
    habit = db.get(Habit, habit_id)
    if not habit:
        raise HTTPException(status_code=404, detail="Habit not found")
    update_data = habitUpdate.model_dump()
    for key, value in update_data.items():
        setattr(habit, key, value)
    Habit.model_validate(update_data)

    db.add(habit)
    db.commit()
    db.refresh(habit)

    return habit

def delete_habit_in_db(habit_id: UUID, db: Session = Depends(get_session)):
    habit = db.get(Habit, habit_id)
    if not habit:
        raise HTTPException(status_code=404, detail="Habit not found")
    db.delete(habit)
    db.commit()
    return {"message": "Habit deleted"}