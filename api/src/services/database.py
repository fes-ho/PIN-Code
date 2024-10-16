from sqlmodel import SQLModel, Session, create_engine
from services.config import get_settings
from models import *

engine = create_engine(get_settings().connection_string)

def create_db_and_tables():
    # The metadata is a collection of tables
    SQLModel.metadata.create_all(engine)

def get_session():
    with Session(engine) as session:
        yield session

def get_member_by_id(member_id: int):
    session_generator = get_session()
    session = next(session_generator)
    try :
        member = session.get(Member, member_id)
        return member
    finally:
        session.close()
