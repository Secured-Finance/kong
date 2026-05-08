########################################
# providers.tf — shared environment
########################################
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.38"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.38"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
