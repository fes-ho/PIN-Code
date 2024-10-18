from fastapi import FastAPI
from dotenv import load_dotenv
from services import create_db_and_tables

# Load the environment variables
load_dotenv()

# Create the database and tables
create_db_and_tables()

app = FastAPI()
@app.get("/")
def read_root():
    return {"message": "Hello, World!"}

@app.get("/health")
def read_root():
    return {"message": "Healthy!"}
