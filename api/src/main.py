from fastapi import FastAPI
from dotenv import load_dotenv
from services import create_db_and_tables
from routers import router as api_router
from scripts import insert_test_member

# Load the environment variables
load_dotenv()

# Create the database and tables
create_db_and_tables()

app = FastAPI(
    responses={404: {"description": "Not found"}},
)
app.include_router(api_router)

# insert_test_member()