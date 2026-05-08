########################################
# iam module outputs
########################################
output "sa_web_email" {
  description = "Web service account email"
  value       = google_service_account.sa_web.email
}

output "sa_jobs_email" {
  description = "Jobs service account email"
  value       = google_service_account.sa_jobs.email
}
