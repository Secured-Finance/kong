########################################
# iam module variables
########################################
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "sa_web_name" {
  description = "Service account name for web service"
  type        = string
}

variable "sa_jobs_name" {
  description = "Service account name for jobs service"
  type        = string
}
