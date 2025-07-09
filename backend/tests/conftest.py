import os
import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from fastapi.testclient import TestClient

# Set env vars before importing app
os.environ.setdefault("SECRET_KEY", "testsecret")
os.environ.setdefault("DATABASE_URL", "sqlite:///./test.db")
os.environ.setdefault("REDIS_URL", "memory://")
os.environ.setdefault("FRONTEND_URL", "http://testserver")

from fastapi_app.database import Base
from fastapi_app.dependencies import get_db
from fastapi_app.main import app
from fastapi_app.rate_limiter import limiter

engine = create_engine(os.environ["DATABASE_URL"], connect_args={"check_same_thread": False})
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

@pytest.fixture(scope="function")
def db_session():
    Base.metadata.create_all(bind=engine)
    session = TestingSessionLocal()
    try:
        yield session
    finally:
        session.close()
        Base.metadata.drop_all(bind=engine)

@pytest.fixture(scope="function")
def client(db_session):
    def override_get_db():
        try:
            yield db_session
        finally:
            pass
    app.dependency_overrides[get_db] = override_get_db
    limiter.reset()
    return TestClient(app, raise_server_exceptions=False)
