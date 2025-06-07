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

# Install Playwright
RUN playwright install --with-deps

# Copy application files
COPY . .

# Make start script executable
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expose port expected by Cloud Run
EXPOSE 8000

# Start FastAPI server only (not Redis)
CMD ["/app/start.sh"]
