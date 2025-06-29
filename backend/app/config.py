import os
from dotenv import load_dotenv

load_dotenv()

# Получаем абсолютный путь до ca.crt
BASE_DIR = os.path.abspath(os.path.dirname(__file__))
CA_PATH = os.path.join(BASE_DIR, '..', 'ca.crt')

class Config:
    SQLALCHEMY_DATABASE_URI = (
        f"postgresql+psycopg2://{os.getenv('POSTGRESQL_USER')}:{os.getenv('POSTGRESQL_PASSWORD')}"
        f"@{os.getenv('POSTGRESQL_HOST')}:{os.getenv('POSTGRESQL_PORT')}/{os.getenv('POSTGRESQL_DBNAME')}"
        f"?sslmode=verify-full&sslrootcert={CA_PATH}"
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False
