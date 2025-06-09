FROM python:3.10-slim

# Prevent Python from writing .pyc files and enable stdout logs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies for Playwright Chromium
RUN apt-get update && apt-get install -y \
    curl wget build-essential \
    libglib2.0-0 libnss3 libgconf-2-4 libfontconfig1 \
    libxss1 libasound2 libxtst6 libatk1.0-0 libgtk-3-0 \
    libx11-xcb1 libxcursor1 libgdk-pixbuf2.0-0 \
    libpangocairo-1.0-0 libcairo-gobject2 \
 && apt-get clean

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright and required browsers
RUN playwright install --with-deps

# Copy your application files
COPY . .

# Make start script executable
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expose the port (Cloud Run uses PORT env)
EXPOSE 8000

# Start the FastAPI app via start.sh
CMD ["/app/start.sh"]
