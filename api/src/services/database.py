from sqlalchemy import text
from sqlmodel import SQLModel, Session, create_engine 
from services import get_settings

engine = create_engine(get_settings().connection_string)

def create_db_and_tables():
    SQLModel.metadata.create_all(engine)

def get_session():
    with Session(engine) as session:
        yield session

def drop_all_tables():
    SQLModel.metadata.drop_all(engine)

def empty_db_data():
    with Session(engine) as session:
        for table in reversed(SQLModel.metadata.sorted_tables):
            statement = text(f"DELETE FROM {table.name}")
            # We need to use the session.execute() method to execute raw SQL
            session.execute(statement)
        session.commit()