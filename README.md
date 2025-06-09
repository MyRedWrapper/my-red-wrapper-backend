# MyRedWrapper Backend

This is the backend service for **MyRed**, built with **FastAPI** and powered by **Playwright** for browser automation. It supports both local development and production deployment (e.g. to Google Cloud Run).

---

## Features

- FastAPI-powered REST API and WebSocket support  
- Playwright browser automation (headless Chromium)  
- Environment-based config for local and production  
- Dockerized for easy deployment

---

## Requirements

- Python 3.10+
- Docker (for deployment)
- Redis
- Google Cloud SDK (for deploying to Cloud Run)

---

## Local Development

### 1. Clone the repo

```bash
git clone https://github.com/MyRedWrapper/my-red-wrapper-backend.git
cd my-red-wrapper-backend
```
### 2. Create a virtual environment and install dependencies
```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
playwright install
```
### 3. Running the backend
#### Terminal One
```bash 
redis-server
uvicorn app.main:app --host 0.0.0.0 --port 8000   
```
#### Terminal Two 
```bash
 PYTHONPATH=. python app/job_worker.py
```

## Production Development

### 1. Build Docker image
```bash 
docker build -t myred-backend .
```
### 2. Deploy to Google Cloud Run
```bash 
gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/myred-backend
gcloud run deploy myred-backend \
  --image gcr.io/YOUR_PROJECT_ID/myred-backend \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```
### 3. WebSocket Endpoint
```bash 
wws://myred-backend-211398327691.us-central1.run.app/ws/job-status/{job_id}
```

## Configuration
Controlled via a boolean flag in **config.py**:
```python
isProd = False  # Set to True for production
```



