from fastapi import FastAPI
from dotenv import load_dotenv
from services import create_db_and_tables

load_dotenv()
create_db_and_tables()

app = FastAPI()
@app.get("/")
def read_root():
    return {"message": "Hello, World!"}