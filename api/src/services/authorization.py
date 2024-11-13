import os
from fastapi import HTTPException, Request
from jose import ExpiredSignatureError, JWTError, jwt
from services import get_settings, logger

from .utils.jwt_utils import get_jwt_from_auth_header


def verify_jwt(request: Request):
    auth_header = request.headers.get('Authorization')

    if not auth_header:
        raise HTTPException(status_code=401, detail="Authorization header missing")

    token = get_jwt_from_auth_header(auth_header)

    appSettings = get_settings()
    
    try:
        return jwt.decode(token, appSettings.secret_jwt_key, algorithms=['HS256'], audience="authenticated")

    except ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token expired")

    except JWTError as e:
        logger.info(e)
        raise HTTPException(status_code=401, detail="Invalid token")