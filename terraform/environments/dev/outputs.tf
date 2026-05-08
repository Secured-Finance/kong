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

# Artifact Registry
output "artifact_registry_repo" {
  value = module.artifact_registry.artifact_registry_repo_id
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
