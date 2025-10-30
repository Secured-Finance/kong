########################################
# outputs.tf
########################################
output "network_self_link" { value = google_compute_network.vpc.self_link }
output "subnet_self_link"  { value = google_compute_subnetwork.subnet.self_link }
output "vpc_connector_name" { value = google_vpc_access_connector.serverless_connector.name }

output "redis_host" { value = google_redis_instance.redis.host }
output "redis_port" { value = google_redis_instance.redis.port }

output "artifact_registry_repo" { value = google_artifact_registry_repository.repo.id }

output "sa_web_email"    { value = google_service_account.sa_web.email }
output "sa_ingest_email" { value = google_service_account.sa_ingest.email }
output "sa_jobs_email"   { value = google_service_account.sa_jobs.email }
