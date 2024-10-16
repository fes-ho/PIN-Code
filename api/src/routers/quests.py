from fastapi import APIRouter

router = APIRouter(
    tags=["quests"],
)

@router.get("/{member_id}/quests")
def get_member_quests():
    return {"Hello": "World"}
