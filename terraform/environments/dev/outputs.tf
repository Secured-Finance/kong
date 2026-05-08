########################################
# outputs.tf — dev environment outputs
########################################

# Networking outputs
output "network_self_link" {
  value = module.networking.network_self_link
}

output "subnet_self_link" {
  value = module.networking.subnet_self_link
}

output "vpc_connector_name" {
  value = module.networking.vpc_connector_name
}

# GCE instance outputs
output "gce_instance_name" {
  value = module.gce.gce_instance_name
}

output "gce_instance_zone" {
  value = module.gce.gce_instance_zone
}

output "gce_external_ip" {
  value = module.gce.gce_external_ip
}

output "gce_internal_ip" {
  value = module.gce.gce_internal_ip
}

output "redis_host" {
  value = module.gce.redis_host
}

output "redis_port" {
  value = module.gce.redis_port
}

# Artifact Registry (from shared state)
output "artifact_registry_repository_url" {
  description = "Artifact Registry repository URL (from shared infrastructure)"
  value       = data.terraform_remote_state.shared.outputs.artifact_registry_repository_url
}

# Service accounts
output "sa_web_email" {
  value = module.iam.sa_web_email
}

output "sa_gce_email" {
  value = module.gce.sa_gce_email
}

output "sa_jobs_email" {
  value = module.iam.sa_jobs_email
}

# WIF outputs (from shared state)
output "wif_provider_resource_name" {
  description = "Fully-qualified Workload Identity Provider resource name for GitHub Actions (from shared infrastructure)"
  value       = data.terraform_remote_state.shared.outputs.wif_provider_resource_name
}

output "ci_service_account_email" {
  description = "Service Account email used by GitHub Actions (from shared infrastructure)"
  value       = data.terraform_remote_state.shared.outputs.ci_service_account_email
}
