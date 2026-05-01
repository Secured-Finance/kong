########################################
# notes.run.tf (comment only) — deployment notes
########################################
# Architecture overview:
# - Cloud Run: web service (deployed via GitHub Actions)
# - GCE: ingest service + Redis (single instance)
# - Database: External managed TimescaleDB service
#
# Deployment steps:
# 1. Deploy infrastructure with Terraform:
#    - Copy terraform.tfvars.example to terraform.tfvars and configure
#    - Run: terraform init && terraform apply
#    - This creates: VPC, GCE instance, Artifact Registry, Service Accounts
#
# 2. Deploy GCE instance setup:
#    - terraform apply creates GCE with startup script (Docker, Bun, Redis)
#    - SSH to the instance: gcloud compute ssh kong-ingest-redis --zone=<zone>
#    - Clone the repository: git clone <repo-url> /opt/kong
#    - Install dependencies: cd /opt/kong && bun install
#    - Configure environment variables from Secret Manager
#    - Start ingest service: systemctl start kong-ingest
#
# 3. Cloud Run web service:
#    - Deployed automatically via GitHub Actions (.github/workflows/deploy.yml)
#    - GitHub Actions builds Docker image and pushes to Artifact Registry
#    - GitHub Actions deploys to Cloud Run with appropriate environment variables
#
# 4. SSH access to GCE for terminal:
#    - gcloud compute ssh kong-ingest-redis --zone=<zone>
#    - cd /opt/kong && bun run terminal
