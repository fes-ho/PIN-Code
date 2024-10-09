from fastapi import FastAPI
from .database import create_db_and_tables
from contextlib import asynccontextmanager

@asynccontextmanager
async def lifespan(app: FastAPI):
    create_db_and_tables()
    yield

app = FastAPI(lifespan=lifespan)
@app.get("/")
def read_root():
    return {"message": "Hello, World!"}