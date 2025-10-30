########################################
# main.tf — APIs & random suffix
########################################
resource "random_id" "suffix" {
  byte_length = 2
}

# Enable required services/APIs
locals {
  services = [
    "run.googleapis.com",                # Cloud Run
    "iam.googleapis.com",               # IAM
    "artifactregistry.googleapis.com",  # Artifact Registry
    "vpcaccess.googleapis.com",         # Serverless VPC Access
    "compute.googleapis.com",           # VPC/Subnet
    "redis.googleapis.com"              # Memorystore
  ]
}

resource "google_project_service" "required" {
  for_each           = toset(local.services)
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}
