def get_jwt_from_auth_header(auth_header: str):
    return auth_header.split(" ")[1]