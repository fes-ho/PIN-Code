from sqlmodel import SQLModel

class MemberBase(SQLModel):
    username: str
    image: str = 'base_avatar.png'
    
class MemberRead(MemberBase):
    id: int
    username: str