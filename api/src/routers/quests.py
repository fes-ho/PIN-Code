from uuid import UUID
from fastapi import APIRouter, Depends
from dependencies import verify_member_id
from cruds import read_quests_by_member, update_quest_duration_in_db
from services import get_session
from schemas import QuestDurationUpdate

router = APIRouter(
    tags=["quests"],
    dependencies=[Depends(verify_member_id)]
)

@router.get("/{member_id}/quests")
def get_quests_by_member(
    member_id: UUID, 
    db=Depends(get_session)
):
    return read_quests_by_member(member_id, db)

@router.patch("/quests/{quest_id}/duration")
def update_quest_duration(
    quest_id: UUID,
    duration_update: QuestDurationUpdate,
    db=Depends(get_session)
):
    return update_quest_duration_in_db(
        quest_id, 
        duration_update.duration,
        duration_update.estimated_duration,
        db
    )