########################################
# main.tf — Shared infrastructure (environment-agnostic resources)
########################################

# Enable required services/APIs for shared resources
locals {
  services = [
    "iam.googleapis.com",              # IAM
    "artifactregistry.googleapis.com", # Artifact Registry
    "iamcredentials.googleapis.com",   # Workload Identity Federation
    "sts.googleapis.com"               # Security Token Service (WIF)
  ]
}

resource "google_project_service" "required" {
  for_each           = toset(local.services)
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}

# Artifact Registry module - Docker repository (environment-agnostic)
module "artifact_registry" {
  source = "../../modules/artifact_registry"

  region                  = var.region
  ar_repo_name            = "kong"
  api_services_dependency = google_project_service.required
}

# WIF module - Workload Identity Federation for GitHub Actions (environment-agnostic)
module "wif" {
  source = "../../modules/wif"

  project_id      = var.project_id
  wif_pool_id     = "gh-pool"
  wif_provider_id = "gh-provider"
  github_org      = "Secured-Finance"
  github_repo     = "kong"
  github_ref      = ""
  sa_ci_name      = "sa-kong-ci"
}
