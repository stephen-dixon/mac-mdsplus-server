#!/usr/bin/env bash
set -euo pipefail

VOLUME_NAME="libtokamap-mdsplus-trees"
CONTAINER_NAME="libtokamap-mdsplus-test"

echo "Stopping server..."
podman rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

echo "Removing volume..."
podman volume rm -f "$VOLUME_NAME" >/dev/null 2>&1 || true

echo "Done."
