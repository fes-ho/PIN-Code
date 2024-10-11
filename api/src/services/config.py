from functools import lru_cache
from pydantic import Field
from pydantic_settings import BaseSettings

class AppSettings(BaseSettings):
    application_env: str = Field(alias="APPLICATION_ENV", default="local")
    connection_string: str = Field(alias="CONNECTION_STRING", default="sqlite:///localDatabase.db")  

@lru_cache()
def get_settings() -> AppSettings:
    return AppSettings()