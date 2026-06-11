#!/usr/bin/env bash
set -euo pipefail

NAME="${1:-vm1}"
IMAGE="${2:-images:ubuntu/22.04}"

# Non-root users generally can run lxc; if script run as root, keep user context
echo "Launching VM '${NAME}' from image '${IMAGE}' (this may download image)."

# Check LXD is available
if ! command -v lxc >/dev/null 2>&1; then
  echo "lxc command not found. Ensure LXD is installed and in PATH."
  exit 1
fi

# Launch VM
# Using --vm instructs LXD to create a full VM instead of a container.
lxc launch "${IMAGE}" --vm "${NAME}"

echo "Waiting 10s for VM to start..."
sleep 10

echo "VM '${NAME}' should be up. Show basic info:"
lxc info "${NAME}"

echo "To connect: lxc console ${NAME}"
echo "To check systemd inside VM: lxc exec ${NAME} -- systemctl status"
