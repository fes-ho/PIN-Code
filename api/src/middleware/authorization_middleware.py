from fastapi import HTTPException, Request
from fastapi.responses import JSONResponse
from api.src.services.authorization import verify_jwt
from main import app

@app.middleware("http")
async def authorization_middleware(request: Request, call_next):
    try:
        verify_jwt(request)

        return await call_next
    
    except HTTPException as exc:
        return JSONResponse(content={"detail": exc.detail}, status_code=exc.status_code)
    
    except Exception as exc:
        return JSONResponse(content={"detail": f"Error: {str(exc)}"}, status_code=500)