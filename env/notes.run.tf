########################################
# notes.run.tf (comment only) — next steps for Cloud Run services
########################################
# Next (out-of-band):
# - Build & push images to Artifact Registry
# - Create Cloud Run services (web/ingest) and Jobs (db-migrate) using these SAs
#   * Attach Serverless VPC Access "${google_vpc_access_connector.serverless_connector.name}"
#   * Set env vars from Secret Manager (DATABASE_URL, REDIS_* , RPC URLs)
#   * For ingest: enable CPU always allocated (instance-based billing), min instances >= 1, concurrency = 1
# - Optionally configure Cloud Scheduler + Pub/Sub to trigger Cloud Run Jobs
