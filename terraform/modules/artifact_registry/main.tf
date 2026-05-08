########################################
# artifact_registry module — Docker repo
########################################
resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = var.ar_repo_name
  description   = "Kong containers"
  format        = "DOCKER"
  depends_on    = [var.api_services_dependency]
}
