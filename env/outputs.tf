########################################
# outputs.tf
########################################
output "network_self_link" { value = google_compute_network.vpc.self_link }
output "subnet_self_link"  { value = google_compute_subnetwork.subnet.self_link }
output "vpc_connector_name" { value = google_vpc_access_connector.serverless_connector.name }

# GCE instance outputs
output "gce_instance_name"       { value = google_compute_instance.kong_gce.name }
output "gce_instance_zone"       { value = google_compute_instance.kong_gce.zone }
output "gce_external_ip"         { value = google_compute_instance.kong_gce.network_interface[0].access_config[0].nat_ip }
output "gce_internal_ip"         { value = google_compute_instance.kong_gce.network_interface[0].network_ip }
output "redis_host"              { value = google_compute_instance.kong_gce.network_interface[0].network_ip }
output "redis_port"              { value = "6379" }

# Artifact Registry
output "artifact_registry_repo" { value = google_artifact_registry_repository.repo.id }

# Service accounts
output "sa_web_email" { value = google_service_account.sa_web.email }
output "sa_gce_email" { value = google_service_account.sa_gce.email }
output "sa_jobs_email" { value = google_service_account.sa_jobs.email }
