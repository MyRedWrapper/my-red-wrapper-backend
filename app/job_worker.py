from rq import Worker, Queue
import redis
from config.config import redis_address

redis_conn = redis.Redis(host=redis_address, port=6379, db=0)

if __name__ == "__main__":
    worker = Worker([Queue("default", connection=redis_conn)], connection=redis_conn)
    worker.work()
