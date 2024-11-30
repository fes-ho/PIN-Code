from fastapi import FastAPI, Request, openapi, Depends
from dotenv import load_dotenv
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from fastapi.security import HTTPBearer
from fastapi.openapi.docs import get_swagger_ui_html
from fastapi.openapi.utils import get_openapi
from middleware import AuhtorizationMiddleware
import uvicorn
from services import create_db_and_tables, drop_all_tables, empty_db_data, logger
from routers import member_router as member_router, router as health_router
from scripts import populate_initial_data
import os

logger.info("Loading the environment variables")
load_dotenv()

bearer_scheme = HTTPBearer(
    bearerFormat="JWT",
    description=(
        "Enter your JWT token. Example format: Bearer eyJhbGciOiJIUzI1..."
        "\n\nNote: Include 'Bearer ' before your token."
    ),
    auto_error=True
)

app = FastAPI(
    title="Your API",
    description="API documentation with JWT Bearer authentication",
    version="1.0.0",
    swagger_ui_parameters={"persistAuthorization": True},
)

def custom_openapi():
    if app.openapi_schema:
        return app.openapi_schema

    openapi_schema = get_openapi(
        title=app.title,
        version=app.version,
        description=app.description,
        routes=app.routes,
        servers=[{"url": "/"}],
    )

    # Preserve existing schemas
    if "components" not in openapi_schema:
        openapi_schema["components"] = {}
    
    if "schemas" not in openapi_schema["components"]:
        openapi_schema["components"]["schemas"] = {}

    # Add JWT security scheme
    openapi_schema["components"]["securitySchemes"] = {
        "Bearer": {
            "type": "http",
            "scheme": "bearer",
            "bearerFormat": "JWT",
        }
    }

    # Apply security to all paths except /health
    openapi_schema["security"] = []  # Remove global security
    
    # Add security to each path individually except /health
    for path, path_obj in openapi_schema["paths"].items():
        if path != "/health":
            for method in path_obj:
                if "security" not in path_obj[method]:
                    path_obj[method]["security"] = [{"Bearer": []}]

    app.openapi_schema = openapi_schema
    return app.openapi_schema

app.openapi = custom_openapi

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    logger.error(f"Validation error: {exc} for request {request.url}")
    return JSONResponse(
        status_code=422,
        content={"detail": exc.errors(), "body": exc.body},
    )

# Include routers
app.include_router(
    member_router,
    dependencies=[Depends(bearer_scheme)],
)
app.include_router(health_router)

# Add middleware
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
    uvicorn.run(
        "main:app",
        host=host,
        port=port,
        reload=True
    )