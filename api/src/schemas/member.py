from sqlmodel import SQLModel

class MemberBase(SQLModel):
    username: str
    
class MemberRead(MemberBase):
    id: int
    username: str