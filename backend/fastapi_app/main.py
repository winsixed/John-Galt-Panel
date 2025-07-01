from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI
from .database import Base, engine
from .routers import api_router

Base.metadata.create_all(bind=engine)
app = FastAPI(title="John Galt Panel API")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])

app.include_router(api_router)
