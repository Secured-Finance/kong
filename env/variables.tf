########################################
# variables.tf
########################################
variable "project_id" {
  type = string
}

variable "region" {
  type    = string
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

# Memorystore for Redis
variable "redis_name" {
  type    = string
  default = "redis-kong"
}

variable "redis_tier" {
  type    = string
  default = "STANDARD_HA" # highly available
}

variable "redis_size_gb" {
  type    = number
  default = 5
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

variable "sa_ingest_name" {
  type    = string
  default = "sa-kong-ingest"
}

variable "sa_jobs_name" {
  type    = string
  default = "sa-kong-jobs"
}
