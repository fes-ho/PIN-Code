from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import PlainTextResponse
from cruds import read_members, get_member_username_by_id, get_member_by_id
from services import get_session
from uuid import UUID

router = APIRouter(
    tags=["members"],
)

@router.get("/")
def get_all_members(
    db = Depends(get_session)
):
    return read_members(db)

@router.get("/{id}") 
def get_member(
    id: UUID,
    db = Depends(get_session)
):
    member = get_member_by_id(id, db)
    if member is None:
        raise HTTPException(status_code=404, detail="Member not found")
    return member

@router.get("/{id}/username", response_class=PlainTextResponse, status_code=201)
def get_member_username(
    id: UUID,
    db = Depends(get_session)
):
    username = get_member_username_by_id(id, db)

    if username is None:
        raise HTTPException(status_code=404, detail="Member not found")
    return username
