from fastapi import APIRouter

router = APIRouter(
    tags=["tasks"],
)

@router.get("/{member_id}/tasks")
def get_member_tasks():
    return {"Hello": "World"}