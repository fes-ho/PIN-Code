from pydantic import BaseModel

class QuestDurationUpdate(BaseModel):
    duration: int
    estimated_duration: int | None = None 