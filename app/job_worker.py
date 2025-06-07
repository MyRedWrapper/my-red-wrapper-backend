from rq import Worker, Queue
import redis

redis_conn = redis.Redis(host="35.184.236.198", port=6379, db=0)

if __name__ == "__main__":
    worker = Worker([Queue("default", connection=redis_conn)], connection=redis_conn)
    worker.work()
