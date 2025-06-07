#!/bin/bash

redis-server --save "" --appendonly no &

echo "Waiting for Redis to start..."
until redis-cli ping | grep -q PONG; do
  sleep 0.5
done

echo "Redis is ready. Starting server and worker..."

gunicorn -k uvicorn.workers.UvicornWorker app.main:app --bind 0.0.0.0:8000 &

rq worker --with-scheduler --url redis://localhost:6379
