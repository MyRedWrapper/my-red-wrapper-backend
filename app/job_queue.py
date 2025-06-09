from rq import Queue
from rq.job import Job
import redis
import asyncio
from app.playwright_login import perform_login
from config.config import redis_address

redis_conn = redis.Redis(host=redis_address, port=6379, db=0)
queue = Queue("default", connection=redis_conn)


def enqueue_login_job(job_id: str, username: str, password: str):
    queue.enqueue(perform_login, job_id, username, password, job_id=job_id)


async def job_status_stream(job_id: str):
    pubsub = redis_conn.pubsub()
    pubsub.subscribe(job_id)

    try:
        while True:
            message = pubsub.get_message(timeout=1)
            if message and message['type'] == 'message':
                yield {"status": message["data"].decode()}

            job = Job.fetch(job_id, connection=redis_conn)
            if job.get_status() in ["finished", "failed"]:
                yield {
                    "status": job.get_status(),
                    "cookies": job.result if job.get_status() == "finished" else None
                }
                break

            await asyncio.sleep(0.5)
    finally:
        pubsub.unsubscribe(job_id)
