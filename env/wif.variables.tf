########################################
# wif.variables.tf (new variables dedicated to WIF)
########################################
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

