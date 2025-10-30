# ============================================================================
# packages/db/Dockerfile  — Cloud Run Job: DB migrate (Bun monorepo)
# ============================================================================
# syntax=docker/dockerfile:1.6

FROM oven/bun:1.2 AS deps
ENV NODE_ENV=production CI=true
WORKDIR /app
# Copy monorepo root package.json and all workspace package.json files
COPY package.json bun.lock ./
COPY packages/db/package.json ./packages/db/
COPY packages/ingest/package.json ./packages/ingest/
COPY packages/lib/package.json ./packages/lib/
COPY packages/scripts/package.json ./packages/scripts/
COPY packages/terminal/package.json ./packages/terminal/
COPY packages/web/package.json ./packages/web/
# Install dependencies
RUN bun install --frozen-lockfile

FROM node:20-slim AS runtime
ENV NODE_ENV=production CI=true
RUN apt-get update && apt-get install -y --no-install-recommends dumb-init && rm -rf /var/lib/apt/lists/*
WORKDIR /app
# Copy dependencies and migration files
COPY --from=deps /app/node_modules ./node_modules
COPY packages/db ./packages/db
COPY package.json ./
# Run migrations from db package directory
WORKDIR /app/packages/db
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["node", "../../node_modules/db-migrate/bin/db-migrate", "up", "-e", "prd", "--verbose"]
