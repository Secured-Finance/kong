# ============================================================================
# packages/terminal/Dockerfile — Cloud Run Job for non-interactive job execution
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
# Install all dependencies
RUN bun install --frozen-lockfile

FROM oven/bun:1.2-slim AS runtime
ENV NODE_ENV=production CI=true
RUN apt-get update && apt-get install -y --no-install-recommends dumb-init && rm -rf /var/lib/apt/lists/*
WORKDIR /app
# Copy dependencies from deps stage
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/package.json ./
# Copy source code
COPY packages/lib ./packages/lib
COPY packages/ingest ./packages/ingest
COPY packages/terminal ./packages/terminal
COPY config ./config
WORKDIR /app/packages/terminal
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["bun", "run", "job", "--job=fanout-abis"]
