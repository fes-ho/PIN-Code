from uuid import UUID
from fastapi import Depends, HTTPException
from cruds import get_member_by_id
from services import get_session

def verify_member_id(
    member_id: UUID,
    session=Depends(get_session)
):
    member = get_member_by_id(member_id, session)
    if not member:
        raise HTTPException(status_code=404, detail="Member not found")
    return member