from fastapi import WebSocket
from typing import Dict

class ConnectionManager:

    def __init__(self):
        self.active_connections: Dict[str, WebSocket] = {}

    async def connect(self, email: str, websocket: WebSocket):
        await websocket.accept()
        self.active_connections[email] = websocket
        print(f"✅ Connected: {email}")

    def disconnect(self, email: str):
        if email in self.active_connections:
            del self.active_connections[email]
        print(f"❌ Disconnected: {email}")

    async def send_personal_message(self, message: str, from_email: str, to: str):
        if to in self.active_connections:
         websocket = self.active_connections[to]
         await websocket.send_json({
            "from": from_email,
            "message": message
            })
        else:
         print(f"⚠️ User {to} not connected")