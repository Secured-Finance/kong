########################################
# redis.tf — Memorystore for Redis (private IP)
########################################
resource "google_redis_instance" "redis" {
  name               = var.redis_name
  region             = var.region
  tier               = var.redis_tier
  memory_size_gb     = var.redis_size_gb
  authorized_network = google_compute_network.vpc.id
}
