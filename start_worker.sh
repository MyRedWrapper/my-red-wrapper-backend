#!/bin/bash

# Navigate to the project directory
cd ~/my-red-wrapper-backend

# Activate the virtual environment
source ~/venv/bin/activate

# Start Redis if it's not already running
sudo service redis-server start

# Launch RQ worker (you can specify the queue if needed)
rq worker --with-scheduler
