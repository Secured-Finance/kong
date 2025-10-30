########################################
# iam.tf — Service Accounts & IAM bindings (least-privilege runtime SAs)
########################################
resource "google_service_account" "sa_web" {
  account_id   = var.sa_web_name
  display_name = "Kong Web (Next.js/GraphQL) runtime"
}

resource "google_service_account" "sa_ingest" {
  account_id   = var.sa_ingest_name
  display_name = "Kong Ingest (BullMQ worker) runtime"
}

resource "google_service_account" "sa_jobs" {
  account_id   = var.sa_jobs_name
  display_name = "Kong Jobs (db-migrate/admin) runtime"
}

# Common roles for runtime access
locals {
  runtime_roles = [
    "roles/secretmanager.secretAccessor",
    "roles/cloudsql.client",
    "roles/artifactregistry.reader",
    "roles/vpcaccess.user"
  ]
}

resource "google_project_iam_member" "sa_web_roles" {
  for_each = toset(local.runtime_roles)
  project  = var.project_id
  role     = each.key
  member   = "serviceAccount:${google_service_account.sa_web.email}"
}

resource "google_project_iam_member" "sa_ingest_roles" {
  for_each = toset(concat(local.runtime_roles, [
    # Ingest may need additional network scoping; adjust as necessary
  ]))
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.sa_ingest.email}"
}

resource "google_project_iam_member" "sa_jobs_roles" {
  for_each = toset(local.runtime_roles)
  project  = var.project_id
  role     = each.key
  member   = "serviceAccount:${google_service_account.sa_jobs.email}"
}

# Optional: allow redis.viewer to list metrics (not required for connectivity)
resource "google_project_iam_member" "sa_metrics_view" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.sa_ingest.email}"
}
