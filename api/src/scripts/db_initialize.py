from datetime import datetime, timedelta
from sqlite3 import Date
import uuid
from services import get_session
from models import *

def populate_initial_data():
    session_generator = get_session()
    session = next(session_generator)
    init_date = datetime.now()

    try:
        member = Member(
            id= uuid.UUID ("9993a0cb-7b79-48f1-9a03-3843b2ffa642"),
            username="test",
        )
        member2 = Member(
            id = uuid.uuid4(),
            username="User2",
        )
        member.friends = [member2]

        member3 = Member(
            username="Ash",
        )

        member4 = Member(
            username="Pepe",
        )

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
        task2 = Task(
            name="Task 2",
            description="Description 2",
            icon="49234",
            date=init_date - timedelta(days=2),
            estimated_duration=20,
            duration=20,
            member_id=member.id,
            is_completed=True
        )
        task3 = Task(
            name="Task 3",
            description="Description 3",
            icon="92432",
            date=init_date - timedelta(days=3),
            estimated_duration=25,
            duration=25,
            member_id=member.id,
            is_completed=True
        )
        task4 = Task(
            name="Task 4",
            description="Description 4",
            icon="23423",
            date=init_date - timedelta(days=5),
            estimated_duration=15,
            duration=15,
            member_id=member.id,
            is_completed=True
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
        session.add(member3)
        session.add(member4)
        session.add(task2)
        session.add(task3)
        session.add(task4)
        session.commit()
    finally:
        session.close()