# ============================================================================
# packages/web/Dockerfile  — Next.js/GraphQL (Bun monorepo)
# ============================================================================
# syntax=docker/dockerfile:1.6

FROM oven/bun:1.2 AS deps
ENV NODE_ENV=production NEXT_TELEMETRY_DISABLED=1 CI=true
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

FROM oven/bun:1.2 AS build
ENV NODE_ENV=production NEXT_TELEMETRY_DISABLED=1 CI=true
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/packages ./packages
# Copy source code
COPY packages/lib ./packages/lib
COPY packages/web ./packages/web
COPY package.json bun.lock ./
# Build web package
WORKDIR /app/packages/web
RUN bun run build

FROM oven/bun:1.2-slim AS runtime
ENV NODE_ENV=production NEXT_TELEMETRY_DISABLED=1 PORT=8080
RUN apt-get update && apt-get install -y --no-install-recommends dumb-init && rm -rf /var/lib/apt/lists/*
WORKDIR /app
# Copy monorepo root node_modules (contains hoisted dependencies)
COPY --from=build /app/node_modules ./node_modules
# Copy built artifacts
COPY --from=build /app/packages/web/.next ./packages/web/.next
COPY --from=build /app/packages/web/package.json ./packages/web/
COPY --from=build /app/packages/web/public ./packages/web/public
# Copy root package.json for workspace resolution
COPY --from=build /app/package.json ./
WORKDIR /app/packages/web
EXPOSE 8080
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["bun", "run", "start"]


