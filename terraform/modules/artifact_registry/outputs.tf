########################################
# artifact_registry module outputs
########################################
output "artifact_registry_repo_id" {
  description = "Artifact Registry repository ID"
  value       = google_artifact_registry_repository.repo.id
}
