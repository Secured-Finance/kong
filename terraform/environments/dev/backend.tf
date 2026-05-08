########################################
# backend.tf — Terraform state backend configuration
########################################
# Uncomment and configure when using remote state (e.g., GCS bucket)
# terraform {
#   backend "gcs" {
#     bucket = "your-terraform-state-bucket"
#     prefix = "terraform/environments/dev"
#   }
# }

# For now, using local state
# IMPORTANT: Do not commit terraform.tfstate or terraform.tfstate.backup to git
