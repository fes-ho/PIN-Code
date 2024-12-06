from enum import member
import stat
from uuid import UUID

from fastapi import Depends, HTTPException
from sqlmodel import Session, select

from models import Member

from .member import get_member_by_id
from services import get_session

# TODO refactor validation for not duplicating code

def add_friend(id: UUID, friend_id: UUID, db: Session = Depends(get_session)):
    friend_member = get_member_by_id(friend_id)
    if friend_member is None:
        raise HTTPException(status_code=404, detail="Friend not found")
    
    member = get_member_by_id(id)
    if member is None:
        raise HTTPException(status_code=404, detail="Member not found")
    
    if member.friends is None:
        member.friends = []

    if friend_member in member.friends:
        raise HTTPException(status_code=400, detail="Friend already added")
    
    member.friends.append(friend_member)
    db.commit()

    return friend_member

def delete_friend(id: UUID, friend_id: UUID, db: Session = Depends(get_session)):
    friend_member = get_member_by_id(friend_id)
    if friend_member is None:
        raise HTTPException(status_code=404, detail="Friend not found")
    
    member = get_member_by_id(id)
    if member is None:
        raise HTTPException(status_code=404, detail="Member not found")
    
    if member.friends is None:
        raise HTTPException(status_code=400, detail="No friends for member")

    if friend_member in member.friends:
        member.friends.remove(friend_member)
        return
    
    raise HTTPException(status_code=400, detail="Friend member is not an actual friend of the member")

def get_member_friends(id: UUID, db: Session = Depends(get_session)):
    member = get_member_by_id(id, db)
    if member is None:
        raise HTTPException(status_code=404, detail="Member not found")
    
    return member.friends