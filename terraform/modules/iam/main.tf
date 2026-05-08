########################################
# iam module — Service Accounts & IAM bindings (least-privilege runtime SAs)
########################################
resource "google_service_account" "sa_web" {
  account_id   = var.sa_web_name
  display_name = "Kong Web (Next.js/GraphQL) runtime"
}

# Service account for jobs (db-migrate) - kept for future use
resource "google_service_account" "sa_jobs" {
  account_id   = var.sa_jobs_name
  display_name = "Kong Jobs (db-migrate/admin) runtime"
}

# Common roles for web service account
locals {
  web_roles = [
    "roles/secretmanager.secretAccessor",
    "roles/artifactregistry.reader"
  ]
}

resource "google_project_iam_member" "sa_web_roles" {
  for_each = toset(local.web_roles)
  project  = var.project_id
  role     = each.key
  member   = "serviceAccount:${google_service_account.sa_web.email}"
}

# Common roles for jobs service account
locals {
  jobs_roles = [
    "roles/secretmanager.secretAccessor",
    "roles/artifactregistry.reader"
  ]
}

resource "google_project_iam_member" "sa_jobs_roles" {
  for_each = toset(local.jobs_roles)
  project  = var.project_id
  role     = each.key
  member   = "serviceAccount:${google_service_account.sa_jobs.email}"
}
