from datetime import datetime
from sqlite3 import Date
from services import get_session
from models import *

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
        task = Task(
            name="Test Task",
            description="Test Description",
            icon="12342",
            date=datetime.fromisoformat("2024-03-03 00:00:00"),
            estimated_duration=30,
            duration=30,
            member_id=member.id,
        )
        frequency = Frequency(
            daily=False,
            days_of_the_week=[],
            days_of_the_month=[1,14,31],
            habit_id=habit.id
        )
        quest = Quest(
            habit_id=habit.id,
            date=Date(2024, 3, 3),
            currentCount=0
        )
        
        Frequency.model_validate(frequency)
        session.add(task)
        session.add(frequency)
        session.add(member)
        session.add(habit)
        session.add(quest)
        session.commit()
    finally:
        session.close()