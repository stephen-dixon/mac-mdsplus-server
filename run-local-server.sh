#!/usr/bin/env bash
set -euo pipefail

IMAGE_TOOLS="localhost/local-mdsplus-arm64"
# IMAGE_TOOLS="local-mdsplus-tools"
# IMAGE_SERVER="mdsplus/mdsplus:tree-server-latest"

VOLUME_NAME="libtokamap-mdsplus-trees"
CONTAINER_NAME="libtokamap-mdsplus-test"
PORT="${MDSPLUS_PORT:-8000}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== MDSplus local test server ==="

# Ensure volume exists
if ! podman volume exists "$VOLUME_NAME"; then
    echo "Creating volume: $VOLUME_NAME"
    podman volume create "$VOLUME_NAME"
fi

# Check if tree already exists
echo "Checking for existing tree..."
if ! podman run --rm \
    -v "${VOLUME_NAME}:/trees" \
    "$IMAGE_TOOLS" \
    sh -c '[ -f /trees/test/test_model.tree ]'; then

    echo "Populating test tree..."

    podman run --rm \
        -v "${VOLUME_NAME}:/trees" \
        -v "${SCRIPT_DIR}:/scripts:ro" \
        -e test_path=/trees/test \
        "$IMAGE_TOOLS" \
        sh -lc 'mkdir -p /trees/test && cd /trees/test && mdstcl < /scripts/init_test_tree.tcl'
else
    echo "Tree already exists, skipping population"
fi

# Stop old container if running
podman rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

echo "Starting MDSplus server on localhost:${PORT}..."

podman run -d \
    --name "$CONTAINER_NAME" \
    -p "${PORT}:8000" \
    -e test_path=/trees/test \
    -v "${VOLUME_NAME}:/trees" \
    "$IMAGE_TOOLS" \
    sh -lc 'printf "* | nobody\n" > /tmp/mdsip.hosts && exec mdsip -m -p 8000 -h /tmp/mdsip.hosts'

echo "Waiting for server..."

for i in {1..10}; do
    if nc -z localhost "$PORT"; then
        echo "✅ MDSplus server is ready"
        exit 0
    fi
    sleep 1
done

echo "⚠️ Server may not be ready yet (check logs)"
echo "Logs:"
podman logs "$CONTAINER_NAME"

exit 1
