########################################
# main.tf — APIs & module orchestration for dev environment
########################################
resource "random_id" "suffix" {
  byte_length = 2
}

# Enable required services/APIs
locals {
  services = [
    "run.googleapis.com",              # Cloud Run
    "iam.googleapis.com",              # IAM
    "artifactregistry.googleapis.com", # Artifact Registry
    "compute.googleapis.com",          # VPC/Subnet/GCE
    "vpcaccess.googleapis.com",        # Serverless VPC Access
    "secretmanager.googleapis.com"     # Secret Manager
  ]
}

resource "google_project_service" "required" {
  for_each           = toset(local.services)
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}

# IAM module - Service accounts for runtime services
module "iam" {
  source = "../../modules/iam"

  project_id   = var.project_id
  sa_web_name  = var.sa_web_name
  sa_jobs_name = var.sa_jobs_name
}

# Networking module - VPC, subnet, firewall, NAT
module "networking" {
  source = "../../modules/networking"

  region                  = var.region
  vpc_name                = var.vpc_name
  subnet_name             = var.subnet_name
  router_name             = var.router_name
  nat_name                = var.nat_name
  vpc_connector_name      = var.vpc_connector_name
  firewall_ssh_name       = var.firewall_ssh_name
  firewall_redis_name     = var.firewall_redis_name
  subnet_ip_cidr          = var.subnet_ip_cidr
  vpc_connector_ip_cidr   = var.vpc_connector_ip_cidr
  api_services_dependency = google_project_service.required
}

# Artifact Registry module - Docker repository
module "artifact_registry" {
  source = "../../modules/artifact_registry"

  region                  = var.region
  ar_repo_name            = var.ar_repo_name
  api_services_dependency = google_project_service.required
}

# GCE module - Compute instance for ingest + Redis
module "gce" {
  source = "../../modules/gce"

  project_id              = var.project_id
  gce_instance_name       = var.gce_instance_name
  gce_machine_type        = var.gce_machine_type
  gce_zone                = var.gce_zone
  gce_boot_disk_size_gb   = var.gce_boot_disk_size_gb
  sa_gce_name             = var.sa_gce_name
  network_name            = module.networking.network_name
  subnet_name             = module.networking.subnet_name
  api_services_dependency = google_project_service.required
  subnet_dependency       = module.networking.subnet_self_link
}

# WIF module - Workload Identity Federation for GitHub Actions
module "wif" {
  source = "../../modules/wif"

  project_id      = var.project_id
  wif_pool_id     = var.wif_pool_id
  wif_provider_id = var.wif_provider_id
  github_org      = var.github_org
  github_repo     = var.github_repo
  github_ref      = var.github_ref
  sa_ci_name      = var.sa_ci_name
}

# Redis module - placeholder for future expansion
module "redis" {
  source = "../../modules/redis"
}

# Cloud Run module - deployment notes and placeholder
module "cloud_run" {
  source = "../../modules/cloud_run"
}
