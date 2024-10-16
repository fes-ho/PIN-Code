from sqlmodel import SQLModel

class MemberBase(SQLModel):
    username: str
    password: str
    email: str
    
class MemberRead(MemberBase):
    id: int
    email: str