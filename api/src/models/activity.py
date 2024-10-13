from sqlmodel import SQLModel

class Activity(SQLModel):
    icon: str
    name: str
    description: str
    duration: int
    estimated_duration: int