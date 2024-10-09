from sqlmodel import SQLModel, Session, create_engine

DATABASE_URL = "sqlite:///localDatabase.db"
engine = create_engine(DATABASE_URL)

def create_db_and_tables():
    # The metadata is a collection of tables
    SQLModel.metadata.create_all(engine)

def get_session():
    with Session(engine) as session:
        yield session