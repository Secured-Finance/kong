# Terminal Package

Supports both interactive CLI for local development and non-interactive job execution for Cloud Run Jobs.

## Local Development (Interactive CLI)

```bash
bun --filter terminal dev
```

Use the interactive menu to navigate: `Ingest` → `fanout abis` to execute Redis jobs.

## Cloud Run Job Execution (VPC Redis Access)

For accessing Redis inside VPC, run as a non-interactive Cloud Run Job.

### Available Jobs

- `fanout-abis` - Execute fanout job based on ABIs configuration
- `fanout-abis --replay` - Execute fanout job in replay mode
- `fanout-events` - Event fanout
- `fanout-timeseries` - Timeseries fanout
- `fanout-webhooks` - Webhook fanout
- `extract-waveydb` - WaveyDB extraction
- `extract-manuals` - Manual extraction

### Local Testing

```bash
# Basic execution
bun --filter terminal job -- --job=fanout-abis

# Replay mode
bun --filter terminal job -- --job=fanout-abis --replay

# Other jobs
bun --filter terminal job -- --job=extract-waveydb
```

### Cloud Run Job Execution

After deployment, execute with:

```bash
# Execute default job (fanout-abis)
gcloud run jobs execute terminal-fanout-abis --region=asia-northeast1

# For different jobs, create a new job definition
gcloud run jobs create terminal-custom \
  --image asia-northeast1-docker.pkg.dev/PROJECT_ID/kong/kong-terminal:latest \
  --region asia-northeast1 \
  --service-account SA_JOBS \
  --vpc-connector svc-connector-kong \
  --set-env-vars=REDIS_HOST=... \
  --args="bun","run","job.ts","--job=extract-waveydb"

gcloud run jobs execute terminal-custom --region=asia-northeast1
```

### GitHub Actions Execution

The deployment workflow automatically creates the `terminal-fanout-abis` job.
To manually trigger:

```bash
# Using GitHub CLI
gh workflow run deploy-kong

# Or execute directly via GCP Console or gcloud
gcloud run jobs execute terminal-fanout-abis --region=asia-northeast1
```

## Architecture

- **index.ts** - Interactive CLI (local development)
- **job.ts** - Non-interactive job execution (Cloud Run Job)
- **menu/** - Interactive menu implementation
- **Dockerfile** - Container image for Cloud Run Job

## Environment Variables

The following environment variables are required (set via GitHub Actions vars or gcloud command for Cloud Run Jobs):

```
REDIS_HOST
REDIS_PORT (optional)
REDIS_PASSWORD (optional)
POSTGRES_HOST
POSTGRES_PORT
POSTGRES_DATABASE
POSTGRES_USER
POSTGRES_PASSWORD
```
