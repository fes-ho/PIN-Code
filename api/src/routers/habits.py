from uuid import UUID
from fastapi import APIRouter, Depends
from schemas import HabitCreate, HabitDurationUpdate, HabitUpdate, HabitTimeUpdate
from services import get_session
from dependencies import verify_member_id
from cruds import read_habits_by_member, create_habit, update_habit_duration_in_db, delete_habit_in_db, update_habit, update_complete_habit, update_habit_time_in_db

router = APIRouter(
    tags=["habits"],
)

@router.get("/members/{member_id}/habits", dependencies=[Depends(verify_member_id)])
def get_member_habits(
    member_id: UUID, 
    db=Depends(get_session)
):
    return read_habits_by_member(member_id, db)

@router.post("/habits", status_code=201)
def post_habit(
    habitCreate: HabitCreate,
    db=Depends(get_session)
):
    verify_member_id(habitCreate.member_id, db)
    return create_habit(habitCreate, db)

@router.put("/habits/{habit_id}")
def put_habit(
    habit_id: UUID,
    habitUpdate: HabitUpdate,
    db=Depends(get_session)
):
    return update_habit(habit_id, habitUpdate, db)

@router.patch("/habits/{habit_id}/complete")
def patch_complete_habit(
    habit_id: UUID,
    db=Depends(get_session)
):
    return update_complete_habit(habit_id, db)

@router.delete("/habits/{habit_id}", status_code=204)
def delete_habit(
    habit_id: UUID,
    db=Depends(get_session)
):
    return delete_habit_in_db(habit_id, db)

@router.patch("/habits/{habit_id}/duration")
def update_habit_duration(
    habit_id: UUID,
    duration_update: HabitDurationUpdate,
    db=Depends(get_session)
):
    return update_habit_duration_in_db(
        habit_id, 
        duration_update.duration, 
        duration_update.estimated_duration, 
        db
    )

@router.patch("/habits/{habit_id}/time")
def update_habit_time(
    habit_id: UUID,
    time_update: HabitTimeUpdate,
    db=Depends(get_session)
):
    return update_habit_time_in_db(
        habit_id, 
        time_update.dayTime,
        db
    )