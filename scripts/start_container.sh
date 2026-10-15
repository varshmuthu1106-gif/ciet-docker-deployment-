#!/bin/bash
set -e

APP_DIR="/opt/ml-docker-app"
APP_NAME="ml-docker-app"

cd "$APP_DIR"

echo "Starting Docker service..."
systemctl start docker

echo "Building the ML application image..."
docker build -t ml-docker-app:latest .

echo "Removing old container if it exists..."
docker rm -f "$APP_NAME" 2>/dev/null || true

echo "Starting the ML application..."
docker run -d \
  --name "$APP_NAME" \
  --restart unless-stopped \
  -p 8000:8000 \
  ml-docker-app:latest

echo "Checking application health..."
sleep 5
curl -f http://localhost:8000/health

echo "ML application deployed successfully!"
