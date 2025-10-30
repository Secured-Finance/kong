########################################
# wif.main.tf — SA, WIF pool/provider, IAM bindings
########################################

# CI Service Account used by GitHub Actions via WIF
resource "google_service_account" "sa_ci" {
  account_id   = var.sa_ci_name
  display_name = "Kong CI/CD via GitHub Actions"
}

# Minimal permissions for CI to deploy to Cloud Run, push to Artifact Registry,
# read secrets, and connect to SQL/VPC as needed. Adjust to your policy.
locals {
  ci_roles = [
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
    "roles/artifactregistry.writer",
    "roles/secretmanager.secretAccessor",
    "roles/cloudsql.client",
    "roles/vpcaccess.user"
  ]
}

resource "google_project_iam_member" "ci_bindings" {
  for_each = toset(local.ci_roles)
  project  = var.project_id
  role     = each.key
  member   = "serviceAccount:${google_service_account.sa_ci.email}"
}

# Workload Identity Pool
resource "google_iam_workload_identity_pool" "pool" {
  workload_identity_pool_id = var.wif_pool_id
  display_name              = "GitHub Actions Pool"
  description               = "OIDC trust for GitHub Actions"
  disabled                  = false
}

# OIDC Provider for GitHub
resource "google_iam_workload_identity_pool_provider" "provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.wif_provider_id
  display_name                       = "GitHub Actions Provider"
  description                        = "OIDC from token.actions.githubusercontent.com"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_condition = var.github_ref != "" ? "attribute.repository==\"${var.github_org}/${var.github_repo}\" && attribute.ref==\"${var.github_ref}\"" : "attribute.repository==\"${var.github_org}/${var.github_repo}\""

  attribute_mapping = {
    "google.subject"   = "assertion.sub"
    "attribute.actor"  = "assertion.actor"
    "attribute.repository" = "assertion.repository"
    "attribute.ref"    = "assertion.ref"
  }
}

# Allow GitHub (through WIF pool) to impersonate the CI Service Account
# Scope is restricted to the specific repository (and optional ref) via provider condition above.
resource "google_service_account_iam_member" "wif_impersonation" {
  service_account_id = google_service_account.sa_ci.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.pool.name}/attribute.repository/${var.github_org}/${var.github_repo}"
}
