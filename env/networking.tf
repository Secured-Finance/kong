########################################
# networking.tf — VPC, Subnet, VPC Connector, PSC range
########################################
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  depends_on              = [google_project_service.required]
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "subnet-kong"
  ip_cidr_range            = var.subnet_ip_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

# Cloud Router (required for Cloud NAT)
resource "google_compute_router" "router" {
  name       = "router-kong"
  region     = var.region
  network    = google_compute_network.vpc.id
  depends_on = [google_project_service.required]
}

# Cloud NAT (allows VPC resources to access internet)
resource "google_compute_router_nat" "nat" {
  name                               = "nat-kong"
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

# Serverless VPC Access Connector for Cloud Run ↔ VPC (Redis/Cloud SQL private IP)
resource "google_vpc_access_connector" "serverless_connector" {
  name          = "svc-connector-kong"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.vpc_connector_ip_cidr
  depends_on    = [google_project_service.required]
}
