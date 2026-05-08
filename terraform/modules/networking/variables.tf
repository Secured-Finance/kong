########################################
# networking module variables
########################################
variable "region" {
  description = "GCP region"
  type        = string
}

variable "vpc_name" {
  description = "VPC network name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default     = "subnet-kong"
}

variable "router_name" {
  description = "Cloud Router name"
  type        = string
  default     = "router-kong"
}

variable "nat_name" {
  description = "Cloud NAT name"
  type        = string
  default     = "nat-kong"
}

variable "vpc_connector_name" {
  description = "VPC Access Connector name"
  type        = string
  default     = "svc-connector-kong"
}

variable "firewall_ssh_name" {
  description = "SSH firewall rule name"
  type        = string
  default     = "allow-ssh-kong"
}

variable "firewall_redis_name" {
  description = "Redis firewall rule name"
  type        = string
  default     = "allow-redis-kong"
}

variable "subnet_ip_cidr" {
  description = "Subnet IP CIDR range"
  type        = string
}

variable "vpc_connector_ip_cidr" {
  description = "VPC connector IP CIDR range (must be /28 or larger)"
  type        = string
}

variable "api_services_dependency" {
  description = "Dependency on API services being enabled"
  type        = any
  default     = []
}
