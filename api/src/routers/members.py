from webbrowser import get
from fastapi import APIRouter, Depends
from cruds import read_members, get_member_username_by_id
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
def get_member_by_id(
    db = Depends(get_session)
):
    return get_member_by_id

@router.get("/{id}/username", status_code=201)
def get_member_username(
    id: UUID,
    db = Depends(get_session)
):
    return get_member_username_by_id(id, db)