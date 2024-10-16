from fastapi import FastAPI
from dotenv import load_dotenv
from services import create_db_and_tables
from endpoints import router as api_router
from scripts.db_initialize import insert_test_member

# Load the environment variables
load_dotenv()

# Create the database and tables
create_db_and_tables()

app = FastAPI()
app.include_router(api_router)

insert_test_member()
