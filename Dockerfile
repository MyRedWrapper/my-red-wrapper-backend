FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies for Playwright Chromium
RUN apt-get update && apt-get install -y \
    curl wget build-essential \
    libglib2.0-0 libnss3 libgconf-2-4 libfontconfig1 \
    libxss1 libasound2 libxtst6 libatk1.0-0 libgtk-3-0 \
 && apt-get clean

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright dependencies
RUN playwright install --with-deps

# Copy application files
COPY . .

# Make start script executable
RUN chmod +x start.sh

# Expose the port Cloud Run expects
EXPOSE 8000

# Start the FastAPI server (do NOT start Redis here)
CMD ["./start.sh"]
