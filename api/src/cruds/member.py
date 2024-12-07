from math import e
from uuid import UUID
from fastapi import Depends, HTTPException
from sqlmodel import Session, select
from services import get_session
from models import Member


def read_members(db: Session = Depends(get_session)):
    members = db.exec(select(Member)).all()
    return members

def get_member_by_id(member_id: UUID, db: Session = Depends(get_session)):
    member = db.get(Member, member_id)
    return member

def get_member_username_by_id(member_id: UUID, db: Session = Depends(get_session)):
    member = get_member_by_id(member_id, db)
    if member:
        return member.username
    
def update_member(member_id: UUID, image: str, db : Session = Depends(get_session)):
    member = get_member_by_id(member_id, db)
    if member:
        member.image = image
        db.add(member)
        db.commit()
        db.refresh(member)
        return member
    else:
        raise HTTPException(status_code=404, detail="Member not found")