from fastapi import APIRouter, HTTPException
from services.database import get_member_by_id

router = APIRouter()

@router.get("/members/{member_id}/habits")
def get_member_habits(member_id: int):
    member = get_member_by_id(member_id)
    if not member:
        raise HTTPException(status_code=404, detail="Member not found")
    
    habits = member.habits

    return {"member_id": member_id, "habits": habits}


