from uuid import uuid4
from datetime import date
from fastapi.testclient import TestClient
from sqlmodel import Session
from models import Member, Habit, Quest, DayTime

def test_read_quests_by_member(client: TestClient, session: Session):
    # Create test member
    member_id = uuid4()
    member = Member(
        id=member_id,
        username="testuser"
    )
    session.add(member)
    
    # Create test habit
    habit = Habit(
        id=uuid4(),
        name="Test Habit",
        description="Test Description",
        member_id=member_id,
        icon="test_icon.png",
        duration=30,
        estimated_duration=30,
        time=DayTime.MORNING,
        count=1
    )
    session.add(habit)
    
    # Create test quest
    quest = Quest(
        id=uuid4(),
        habit_id=habit.id,
        date=date(2024, 3, 1),
        currentCount=0
    )
    session.add(quest)
    session.commit()

    # Test GET /members/{member_id}/quests endpoint
    response = client.get(f"/members/{member_id}/quests")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 1
    assert data[0]["currentCount"] == 0
    assert data[0]["habit_id"] == str(habit.id)

def test_read_quests_by_member_no_habits(client: TestClient, session: Session):
    # Create test member without habits
    member_id = uuid4()
    member = Member(
        id=member_id,
        username="testuser"
    )
    session.add(member)
    session.commit()

    # Test GET /members/{member_id}/quests endpoint
    response = client.get(f"/members/{member_id}/quests")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 0

def test_read_quests_by_member_multiple_habits(client: TestClient, session: Session):
    # Create test member
    member_id = uuid4()
    member = Member(
        id=member_id,
        username="testuser"
    )
    session.add(member)
    
    # Create multiple habits with quests
    habits_count = 3
    quests_per_habit = 2
    
    for i in range(habits_count):
        habit = Habit(
            id=uuid4(),
            name=f"Test Habit {i}",
            description=f"Test Description {i}",
            member_id=member_id,
            icon="test_icon.png",
            duration=30,
            estimated_duration=30,
            time=DayTime.MORNING,
            count=1
        )
        session.add(habit)
        
        for j in range(quests_per_habit):
            quest = Quest(
                id=uuid4(),
                habit_id=habit.id,
                date=date(2024, 3, j+1),
                currentCount=j
            )
            session.add(quest)
    
    session.commit()

    # Test GET /members/{member_id}/quests endpoint
    response = client.get(f"/members/{member_id}/quests")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == habits_count * quests_per_habit

def test_read_quests_member_not_found(client: TestClient):
    non_existent_id = uuid4()
    response = client.get(f"/members/{non_existent_id}/quests")
    assert response.status_code == 404
    assert response.json()["detail"] == "Member not found"