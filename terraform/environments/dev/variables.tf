########################################
# variables.tf — dev environment variables
########################################
variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_name" {
  type    = string
  default = "vpc-kong"
}

variable "subnet_ip_cidr" {
  type    = string
  default = "10.10.0.0/20"
}

# Serverless VPC Access connector range (must be /28 or larger, non-overlapping)
variable "vpc_connector_ip_cidr" {
  type    = string
  default = "10.8.0.0/28"
}

# GCE instance configuration
variable "gce_instance_name" {
  type    = string
  default = "kong-ingest-redis"
}

variable "gce_machine_type" {
  type    = string
  default = "e2-standard-2"
}

variable "gce_zone" {
  type = string
}

variable "gce_boot_disk_size_gb" {
  type    = number
  default = 50
}

# Artifact Registry
variable "ar_repo_name" {
  type    = string
  default = "kong"
}

# Service accounts (runtimes)
variable "sa_web_name" {
  type    = string
  default = "sa-kong-web"
}

variable "sa_gce_name" {
  type    = string
  default = "sa-kong-gce"
}

variable "sa_jobs_name" {
  type    = string
  default = "sa-kong-jobs"
}

# WIF variables
variable "wif_pool_id" {
  description = "Workload Identity Pool ID (resource short name)"
  type        = string
  default     = "gh-pool"
}

variable "wif_provider_id" {
  description = "Workload Identity Provider ID (resource short name)"
  type        = string
  default     = "gh-provider"
}

variable "github_org" {
  description = "GitHub organization / user name"
  type        = string
  default     = "Secured-Finance"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "kong"
}

# Optional: narrow by branch/tag ref (e.g. "refs/heads/main"). If empty, repo-scoped only.
variable "github_ref" {
  description = "GitHub ref to allow (e.g. refs/heads/main). Leave empty to allow any ref."
  type        = string
  default     = ""
}

# Optional: CI Service Account name (email becomes <name>@<project>.iam.gserviceaccount.com)
variable "sa_ci_name" {
  description = "Service Account name for CI/CD"
  type        = string
  default     = "sa-kong-ci"
}

# Networking resource names
variable "subnet_name" {
  type    = string
  default = "subnet-kong"
}

variable "router_name" {
  type    = string
  default = "router-kong"
}

variable "nat_name" {
  type    = string
  default = "nat-kong"
}

variable "vpc_connector_name" {
  type    = string
  default = "svc-connector-kong"
}

variable "firewall_ssh_name" {
  type    = string
  default = "allow-ssh-kong"
}

variable "firewall_redis_name" {
  type    = string
  default = "allow-redis-kong"
}
