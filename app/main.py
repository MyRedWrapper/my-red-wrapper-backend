from fastapi import FastAPI, WebSocket
from pydantic import BaseModel
from app.job_queue import enqueue_login_job, job_status_stream
import uuid

app = FastAPI()


class LoginRequest(BaseModel):
    username: str
    password: str


@app.post("/simulate-login")
async def simulate_login(req: LoginRequest):
    job_id = str(uuid.uuid4())
    enqueue_login_job(job_id, req.username, req.password)
    return {"job_id": job_id}


@app.websocket("/ws/job-status/{job_id}")
async def ws_status(websocket: WebSocket, job_id: str):
    await websocket.accept()
    async for msg in job_status_stream(job_id):
        await websocket.send_json(msg)

