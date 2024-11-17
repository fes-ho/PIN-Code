import os
import pytest
from fastapi.testclient import TestClient
from sqlmodel import Session, SQLModel
from sqlalchemy.pool import StaticPool
from sqlalchemy import create_engine

from main import app
from services import get_session


@pytest.fixture(name="session")
def session_fixture():
    engine = create_engine(
        "sqlite://",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    SQLModel.metadata.create_all(engine)
    with Session(engine) as session:
        yield session

@pytest.fixture(name="client")
def client_fixture(session: Session):
    def get_session_override():
        return session

    app.dependency_overrides[get_session] = get_session_override
    client = TestClient(app)
    
    # Get the token from the environment variable
    client.headers["Authorization"] = f"Bearer {os.getenv('TEST_USER_TOKEN')}"
    env = os.environ
    
    yield client
    app.dependency_overrides.clear() 