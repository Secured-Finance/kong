########################################
# artifact_registry module variables
########################################
variable "region" {
  description = "GCP region"
  type        = string
}

variable "ar_repo_name" {
  description = "Artifact Registry repository name"
  type        = string
}

variable "api_services_dependency" {
  description = "Dependency on API services being enabled"
  type        = any
  default     = []
}
