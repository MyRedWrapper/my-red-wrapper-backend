#!/bin/bash

# Start FastAPI app via Gunicorn + Uvicorn worker
gunicorn -k uvicorn.workers.UvicornWorker app.main:app \
  --bind 0.0.0.0:8000 \
  --timeout 180 \
  --workers 1
