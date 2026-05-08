########################################
# networking module — VPC, Subnet, VPC Connector, PSC range
########################################
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  depends_on              = [var.api_services_dependency]
}

resource "google_compute_subnetwork" "subnet" {
  name                     = var.subnet_name
  ip_cidr_range            = var.subnet_ip_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

# Cloud Router (required for Cloud NAT)
resource "google_compute_router" "router" {
  name       = var.router_name
  region     = var.region
  network    = google_compute_network.vpc.id
  depends_on = [var.api_services_dependency]
}

# Cloud NAT (allows VPC resources to access internet)
resource "google_compute_router_nat" "nat" {
  name                               = var.nat_name
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }

  depends_on = [google_compute_router.router]
}

# Serverless VPC Access Connector for Cloud Run ↔ GCE (Redis)
resource "google_vpc_access_connector" "serverless_connector" {
  name          = var.vpc_connector_name
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.vpc_connector_ip_cidr
  depends_on    = [var.api_services_dependency]
}

# Firewall rule: Allow SSH access to GCE instance
resource "google_compute_firewall" "allow_ssh" {
  name    = var.firewall_ssh_name
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["kong-gce"]
}

# Firewall rule: Allow Cloud Run to access Redis on GCE
resource "google_compute_firewall" "allow_redis" {
  name    = var.firewall_redis_name
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["6379"]
  }

  source_ranges = [var.subnet_ip_cidr, var.vpc_connector_ip_cidr]
  target_tags   = ["kong-gce"]
}
