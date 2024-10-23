from fastapi import HTTPException, Request
from fastapi.responses import JSONResponse
from services import verify_jwt
from starlette.middleware.base import BaseHTTPMiddleware

class AuhtorizationMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        try:
            verify_jwt(request)

            return await call_next(request)
        
        except HTTPException as exc:
            return JSONResponse(content={"detail": exc.detail}, status_code=exc.status_code)
        
        except Exception as exc:
            return JSONResponse(content={"detail": f"Error: {str(exc)}"}, status_code=500)