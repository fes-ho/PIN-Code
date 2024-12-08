from uuid import UUID
from fastapi import APIRouter, Depends
from cruds import add_friend as add_friend_crud
from cruds import delete_friend as delete_friend_crud
from cruds import get_member_friends
from services import get_session

router = APIRouter(
    tags=["friendship"],
)

@router.post("/{id}/friends/{friend_id}", status_code=201)
def add_friend(
    id: UUID,
    friend_id: UUID,
    db=Depends(get_session)
):
    return add_friend_crud(id, friend_id, db)

@router.delete("/{id}/friends/{friend_id}")
def delete_friend(
    id: UUID,
    friend_id: UUID,
    db=Depends(get_session)
):
    return delete_friend_crud(id, friend_id, db)

@router.get("/{id}/friends")
def get_friends(
    id: UUID,
    db=Depends(get_session)
):
    return get_member_friends(id, db)