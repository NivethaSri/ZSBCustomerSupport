from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from app.core.connection_manager import ConnectionManager
import json

router = APIRouter()
manager = ConnectionManager()

@router.websocket("/chat/ws/{email}")
async def websocket_endpoint(websocket: WebSocket, email: str):

    await manager.connect(email, websocket)

    try:
        while True:
            data = await websocket.receive_text()
            payload = json.loads(data)

            to = payload.get("to")
            message = payload.get("message")

            print(f"📨 {email} → {to}: {message}")

            await manager.send_personal_message(message, email, to)
    except WebSocketDisconnect:
        manager.disconnect(email)