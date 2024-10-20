from sqlite3 import Date
from services import get_session
from models import Member, Habit, DayTime, Quest

def populate_initial_data():
    session_generator = get_session()
    session = next(session_generator)

    try:
        member = Member(
            username="test", 
            password="test", 
            email="test@example.com")
        habit = Habit(
            name="Test Habit",
            description="Test Description",
            member_id=member.id,
            icon="default_icon.png",
            duration=30,
            estimated_duration=30,
            time=DayTime.MORNING,
            count=1
        )
        quest = Quest(
            habit_id=habit.id,
            date=Date(2024, 3, 3),
            currentCount=0
        )

        session.add(member)
        session.add(habit)
        session.add(quest)
        session.commit()
    finally:
        session.close()
        