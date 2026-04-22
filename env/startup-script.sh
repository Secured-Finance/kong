#!/bin/bash
set -euo pipefail

########################################
# GCE Startup Script - Kong Ingest + Redis
########################################

# Update system
apt-get update
apt-get upgrade -y

# Install required packages
apt-get install -y \
  curl \
  git \
  unzip \
  ca-certificates \
  gnupg \
  lsb-release

# Install Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable and start Docker
systemctl enable docker
systemctl start docker

# Configure Docker to use gcloud as credential helper for Artifact Registry
# Set HOME if not set (needed for gcloud configure-docker)
export HOME=${HOME:-/root}
gcloud auth configure-docker asia-northeast1-docker.pkg.dev --quiet

# Install Bun
curl -fsSL https://bun.sh/install | bash
export BUN_INSTALL="/root/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Add Bun to PATH for all users
echo 'export BUN_INSTALL="/root/.bun"' >> /etc/profile.d/bun.sh
echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> /etc/profile.d/bun.sh

# Start Redis container
# Bind to all interfaces (0.0.0.0) to allow VPC access from Cloud Run
docker run -d \
  --name redis \
  --restart unless-stopped \
  -p 6379:6379 \
  redis:7-alpine

# Create Kong app directory
mkdir -p /opt/kong
cd /opt/kong

# Note: Application deployment should be handled separately via CI/CD
# This script only sets up the runtime environment

# Create systemd service for Kong ingest (to be populated by deployment)
cat > /etc/systemd/system/kong-ingest.service <<EOF
[Unit]
Description=Kong Ingest Service
After=network.target docker.service
Requires=docker.service

[Service]
Type=simple
WorkingDirectory=/opt/kong
ExecStart=/root/.bun/bin/bun run start:ingest
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=kong-ingest

[Install]
WantedBy=multi-user.target
EOF

# Enable the service (will start after deployment)
systemctl daemon-reload
systemctl enable kong-ingest.service

echo "GCE startup script completed successfully"
