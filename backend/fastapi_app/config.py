from dotenv import load_dotenv
import os

load_dotenv()

SECRET_KEY = os.getenv("SECRET_KEY")
if not SECRET_KEY:
    raise RuntimeError("SECRET_KEY environment variable not set")

JWT_ISSUER = os.getenv("JWT_ISSUER", "john-galt-panel")
JWT_AUDIENCE = os.getenv("JWT_AUDIENCE", "john-galt-users")

REDIS_URL = os.getenv("REDIS_URL")
if not REDIS_URL:
    raise RuntimeError("REDIS_URL environment variable not set")
if not (REDIS_URL.startswith("rediss://") or REDIS_URL.startswith("memory://")):
    raise ValueError("REDIS_URL must use rediss:// with TLS or memory:// for tests")

FRONTEND_URL = os.getenv("FRONTEND_URL")
if not FRONTEND_URL:
    raise RuntimeError("FRONTEND_URL environment variable not set")

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL environment variable not set")
