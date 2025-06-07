FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl wget build-essential \
    libglib2.0-0 libnss3 libgconf-2-4 libfontconfig1 \
    libxss1 libasound2 libxtst6 libatk1.0-0 libgtk-3-0 \
    redis \
 && apt-get clean

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN playwright install --with-deps

COPY . .

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8000

COPY start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]

