
from dotenv import load_dotenv
import os
load_dotenv()
from fastapi import FastAPI, Depends
from app.routers import auth, chat
from app.core.dependencies import get_current_user
from app.core.database import Base, engine
from app.routers import ai


def create_app() -> FastAPI:

    app = FastAPI(title="ZSB Support Backend")

    # Create DB tables
    Base.metadata.create_all(bind=engine)

    # Include routers
    app.include_router(auth.router)
    app.include_router(chat.router)
    app.include_router(ai.router)
    @app.get("/")
    def root():
        return {"message": "ZSB Backend is running"}

    @app.get("/users/me")
    def read_current_user(current_user: str = Depends(get_current_user)):
        return {"logged_in_user": current_user}

    return app


# 🔥 Required for uvicorn
app = create_app()