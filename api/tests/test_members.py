from uuid import uuid4
from fastapi.testclient import TestClient
from sqlmodel import Session
from models import Member

def test_read_members_empty(client: TestClient):
    response = client.get("/members")
    assert response.status_code == 200
    assert response.json() == []

def test_read_members_with_data(client: TestClient, session: Session):
    # Create test members
    members = [
        Member(id=uuid4(), username="user1"),
        Member(id=uuid4(), username="user2"),
        Member(id=uuid4(), username="user3")
    ]
    for member in members:
        session.add(member)
    session.commit()

    # Test GET /members endpoint
    response = client.get("/members")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 3
    assert {member["username"] for member in data} == {"user1", "user2", "user3"}

def test_get_member_username(client: TestClient, session: Session):
    # Create test member
    member_id = uuid4()
    member = Member(
        id=member_id,
        username="testuser"
    )
    session.add(member)
    session.commit()

    # Test GET /members/{id}/username endpoint
    response = client.get(f"/members/{member_id}/username")
    assert response.status_code == 200
    assert response.text == "testuser"

def test_get_member_username_not_found(client: TestClient):
    non_existent_id = uuid4()
    response = client.get(f"/members/{non_existent_id}/username")
    assert response.status_code == 404

def test_get_member_by_id(client: TestClient, session: Session):
    # Create test member
    member_id = uuid4()
    member = Member(
        id=member_id,
        username="testuser"
    )
    session.add(member)
    session.commit()

    # Test GET /members/{id} endpoint
    response = client.get(f"/members/{member_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == str(member_id)
    assert data["username"] == "testuser"

def test_get_member_by_id_not_found(client: TestClient):
    non_existent_id = uuid4()
    response = client.get(f"/members/{non_existent_id}")
    assert response.status_code == 404 