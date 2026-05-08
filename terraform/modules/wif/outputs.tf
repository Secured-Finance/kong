########################################
# wif module outputs
########################################
output "wif_provider_resource_name" {
  description = "Fully-qualified Workload Identity Provider resource name for GitHub Actions"
  value       = google_iam_workload_identity_pool_provider.provider.name
}

output "ci_service_account_email" {
  description = "Service Account email used by GitHub Actions"
  value       = google_service_account.sa_ci.email
}

output "wif_pool_name" {
  description = "Workload Identity Pool full name"
  value       = google_iam_workload_identity_pool.pool.name
}
