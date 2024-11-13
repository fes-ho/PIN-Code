from uuid import UUID
from fastapi import APIRouter, Depends
from services import get_session
from models import Mood
from cruds import create_mood as create_mood_crud, get_mood as get_mood_crud

router = APIRouter(
    tags=["moods"],
)

@router.post("/mood", status_code=201)
def create_mood(
    mood: Mood,
    db = Depends(get_session)
):
    return create_mood_crud(mood, db)

@router.get("/{id}/mood")
def get_mood(
    id: UUID,
    db = Depends(get_session)
):
    return get_mood_crud(id, db)