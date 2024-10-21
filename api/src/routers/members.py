from fastapi import APIRouter, Depends
from cruds import read_members
from services import get_session

router = APIRouter(
    tags=["members"],
)

@router.get("/")
def get_all_members(
    db = Depends(get_session)
):
    return read_members(db) 