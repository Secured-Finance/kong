########################################
# gce module outputs
########################################
output "sa_gce_email" {
  description = "GCE service account email"
  value       = google_service_account.sa_gce.email
}

output "gce_instance_name" {
  description = "GCE instance name"
  value       = google_compute_instance.kong_gce.name
}

output "gce_instance_zone" {
  description = "GCE instance zone"
  value       = google_compute_instance.kong_gce.zone
}

output "gce_external_ip" {
  description = "GCE instance external IP"
  value       = google_compute_instance.kong_gce.network_interface[0].access_config[0].nat_ip
}

output "gce_internal_ip" {
  description = "GCE instance internal IP"
  value       = google_compute_instance.kong_gce.network_interface[0].network_ip
}

output "redis_host" {
  description = "Redis host (GCE internal IP)"
  value       = google_compute_instance.kong_gce.network_interface[0].network_ip
}

output "redis_port" {
  description = "Redis port"
  value       = "6379"
}
