from fastapi import FastAPI, openapi, Depends
from dotenv import load_dotenv
from fastapi.security import HTTPBearer, OAuth2PasswordBearer
from middleware import AuhtorizationMiddleware
import uvicorn
from services import create_db_and_tables, drop_all_tables, empty_db_data, logger
from routers import member_router as member_router, router as health_router
from scripts import populate_initial_data
import os

logger.info("Loading the environment variables")
load_dotenv()

# Needed for the OpenAPI documentation
bearer_scheme = HTTPBearer()

app = FastAPI(
    responses={404: {"description": "Not found"}},
    dependencies=[Depends(bearer_scheme)],
)

app.include_router(member_router)
app.include_router(health_router)
app.add_middleware(AuhtorizationMiddleware)

if os.getenv("CREATE_DB_AND_TABLES", "false").lower() == "true":
    logger.info("Dropping the database tables")
    drop_all_tables()
    logger.info("Creating the database and tables")
    create_db_and_tables()

if (
    os.getenv("CREATE_DB_AND_TABLES", "false").lower() == "false"
    and os.getenv("CLEAR_DB_DATA", "false").lower() == "true"
):
    logger.info("Clearing the database data")
    empty_db_data()

if os.getenv("POPULATE_INITIAL_DATA", "false").lower() == "true":
    logger.info("Populating initial data")
    populate_initial_data()

if __name__ == "__main__":
    host = os.getenv("HOST", "127.0.0.1")
    port = int(os.getenv("PORT", 8000))
    uvicorn.run(app, host=host, port=port)