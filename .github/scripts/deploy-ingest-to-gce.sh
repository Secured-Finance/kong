#!/bin/bash
set -euo pipefail

# Deploy ingest service to GCE instance
# This script runs on the GCE instance

echo "Deploying ingest service to GCE..."

# Stop existing container if running
sudo docker stop kong-ingest 2>/dev/null || true
sudo docker rm kong-ingest 2>/dev/null || true

# Pull latest image
echo "Pulling latest ingest image: ${IMAGE_INGEST}:latest"
sudo docker pull "${IMAGE_INGEST}:latest"

# Run new container
echo "Starting ingest container..."
sudo docker run -d \
  --name kong-ingest \
  --restart unless-stopped \
  --network host \
  -e KONG_CHAINS="${KONG_CHAINS:-}" \
  -e HTTP_ARCHIVE_1="${RPC_URI_FOR_1}" \
  -e HTTP_FULLNODE_1="${RPC_URI_FOR_1}" \
  -e HTTP_ARCHIVE_314159="${RPC_URI_FOR_314159}" \
  -e HTTP_FULLNODE_314159="${RPC_URI_FOR_314159}" \
  -e GLIF_API_KEY_314="${GLIF_API_KEY_314}" \
  -e GLIF_API_KEY_314159="${GLIF_API_KEY_314159}" \
  -e POSTGRES_HOST="${POSTGRES_HOST}" \
  -e POSTGRES_DATABASE="${POSTGRES_DATABASE}" \
  -e POSTGRES_PORT="${POSTGRES_PORT}" \
  -e POSTGRES_SSL="${POSTGRES_SSL}" \
  -e POSTGRES_SSL_REJECT_UNAUTHORIZED="${POSTGRES_SSL_REJECT_UNAUTHORIZED}" \
  -e POSTGRES_USER="${POSTGRES_USER}" \
  -e POSTGRES_PASSWORD="${POSTGRES_PASSWORD}" \
  -e REDIS_HOST=127.0.0.1 \
  -e REDIS_PORT=6379 \
  "${IMAGE_INGEST}:latest"

echo "Ingest service deployed successfully"
sudo docker ps --filter "name=kong-ingest"
