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
