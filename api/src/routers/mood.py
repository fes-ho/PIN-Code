from datetime import datetime
from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import Uuid
from schemas.mood import MoodBase
from schemas.type_of_mood import TypeOfMood
from services import get_session
from cruds import create_mood as create_mood_crud, get_mood as get_mood_crud, update_mood as update_mood_crud

router = APIRouter(
    tags=["moods"],
)

@router.post("/mood", status_code=201)
def create_mood(
    mood: MoodBase,
    db = Depends(get_session)
):
    return create_mood_crud(mood, db)

@router.get("/{id}/mood/{date}")
def get_mood(
    id: UUID,
    date: datetime,
    db = Depends(get_session)
):
    mood = get_mood_crud(id, date, db)
    if mood is None:
        raise HTTPException(status_code=404, detail="No mood available")
    return mood

@router.put("/mood/{mood_id}/{type_of_mood}")
def update_mood(
    mood_id: UUID,
    type_of_mood: TypeOfMood,
    db = Depends(get_session)
):
    return update_mood_crud(mood_id, type_of_mood, db)