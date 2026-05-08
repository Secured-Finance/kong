########################################
# outputs.tf — shared environment outputs
########################################

# Artifact Registry outputs
output "artifact_registry_repository_url" {
  description = "Artifact Registry repository URL for pulling/pushing images"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/kong"
}

output "artifact_registry_repository_id" {
  description = "Artifact Registry repository ID"
  value       = module.artifact_registry.artifact_registry_repo_id
}

# WIF outputs
output "wif_provider_resource_name" {
  description = "Fully-qualified Workload Identity Provider resource name for GitHub Actions"
  value       = module.wif.wif_provider_resource_name
}

output "ci_service_account_email" {
  description = "Service Account email used by GitHub Actions"
  value       = module.wif.ci_service_account_email
}

output "wif_pool_name" {
  description = "Workload Identity Pool full name"
  value       = module.wif.wif_pool_name
}
