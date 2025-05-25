# Use Python 3.13 as base image
FROM python:3.13-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

RUN mkdir static

# Create the app user
RUN addgroup --system app && adduser --system --group app

# Install system dependencies
RUN apt-get update \
    && apt-get install -y netcat-traditional \
    && apt-get install -y --no-install-recommends \
        build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . .
RUN chmod +x /app/entrypoint.sh

# Chown all the files to the app user
RUN chown -R app:app .

# Change to the app user
USER app

ENTRYPOINT ["/app/entrypoint.sh"]