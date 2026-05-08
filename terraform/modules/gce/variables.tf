########################################
# gce module variables
########################################
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "gce_instance_name" {
  description = "GCE instance name"
  type        = string
}

variable "gce_machine_type" {
  description = "GCE machine type"
  type        = string
}

variable "gce_zone" {
  description = "GCE zone"
  type        = string
}

variable "gce_boot_disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
}

variable "sa_gce_name" {
  description = "Service account name for GCE instance"
  type        = string
}

variable "network_name" {
  description = "VPC network name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "api_services_dependency" {
  description = "Dependency on API services being enabled"
  type        = any
  default     = []
}

variable "subnet_dependency" {
  description = "Dependency on subnet being created"
  type        = any
  default     = []
}
