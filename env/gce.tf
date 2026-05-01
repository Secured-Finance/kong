########################################
# gce.tf — GCE instance for ingest & redis
########################################

# Service account for GCE instance
resource "google_service_account" "sa_gce" {
  account_id   = var.sa_gce_name
  display_name = "Kong GCE instance (ingest + redis)"
}

# IAM roles for GCE service account
locals {
  gce_roles = [
    "roles/secretmanager.secretAccessor",
    "roles/artifactregistry.reader",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter"
  ]
}

resource "google_project_iam_member" "sa_gce_roles" {
  for_each = toset(local.gce_roles)
  project  = var.project_id
  role     = each.key
  member   = "serviceAccount:${google_service_account.sa_gce.email}"
}

# GCE instance for ingest + redis
resource "google_compute_instance" "kong_gce" {
  name         = var.gce_instance_name
  machine_type = var.gce_machine_type
  zone         = var.gce_zone

  tags = ["kong-gce"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = var.gce_boot_disk_size_gb
      type  = "pd-balanced"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.subnet.name

    # Enable external IP for SSH access and internet connectivity
    access_config {
      // Ephemeral external IP
    }
  }

  service_account {
    email  = google_service_account.sa_gce.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = file("${path.module}/startup-script.sh")

  depends_on = [
    google_project_service.required,
    google_compute_subnetwork.subnet
  ]

  allow_stopping_for_update = true
}
