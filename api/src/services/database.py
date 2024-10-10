from sqlmodel import SQLModel, Session, create_engine

from services.config import get_settings
from models import Member

engine = None

def create_db_and_tables():
    # The metadata is a collection of tables
    engine = create_engine(get_settings().connection_string)
    SQLModel.metadata.create_all(engine)

def get_session():
    with Session(engine) as session:
        yield session