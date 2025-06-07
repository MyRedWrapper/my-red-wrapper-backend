#!/bin/bash

echo "Starting FastAPI server..."

gunicorn -k uvicorn.workers.UvicornWorker app.main:app \
  --bind 0.0.0.0:8000 \
  --timeout 180 \
  --workers 1
