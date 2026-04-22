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
    "compute.googleapis.com",           # VPC/Subnet/GCE
    "vpcaccess.googleapis.com",         # Serverless VPC Access
    "secretmanager.googleapis.com"      # Secret Manager
  ]
}

resource "google_project_service" "required" {
  for_each           = toset(local.services)
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}
