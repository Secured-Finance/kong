#!/bin/bash
set -euo pipefail

# Generate chains.local.yaml from KONG_CHAINS environment variable
# Expected format: KONG_CHAINS="mainnet,filecoin,filecoinCalibration"

# Find config directory relative to the script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(cd "${SCRIPT_DIR}/../../../config" && pwd)"

if [ ! -d "${CONFIG_DIR}" ]; then
  echo "ERROR: config directory not found at ${CONFIG_DIR}"
  exit 1
fi

CONFIG_FILE="${CONFIG_DIR}/chains.local.yaml"

if [ -z "${KONG_CHAINS:-}" ]; then
  echo "KONG_CHAINS not set, using default chains.yaml"
  exit 0
fi

echo "Generating ${CONFIG_FILE} from KONG_CHAINS: ${KONG_CHAINS}"

# Create chains.local.yaml
cat > "${CONFIG_FILE}" << EOF
chains: [
EOF

# Parse comma-separated chains and add to YAML
IFS=',' read -ra CHAINS <<< "$KONG_CHAINS"
CHAIN_COUNT=${#CHAINS[@]}

for i in "${!CHAINS[@]}"; do
  chain=$(echo "${CHAINS[$i]}" | xargs)  # trim whitespace

  if [ $i -eq $((CHAIN_COUNT - 1)) ]; then
    # Last item, no comma
    echo "  '${chain}'" >> "${CONFIG_FILE}"
  else
    # Add comma
    echo "  '${chain}'," >> "${CONFIG_FILE}"
  fi
done

echo "]" >> "${CONFIG_FILE}"

echo "Generated ${CONFIG_FILE}:"
cat "${CONFIG_FILE}"
