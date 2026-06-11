#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root: sudo $0"
  exit 1
fi

PRESEED_FILE=/tmp/lxd-preseed.yaml

cat > "${PRESEED_FILE}" <<'EOF'
config: {}
networks:
- config: {}
  description: ""
  name: lxdbr0
  type: bridge
storage_pools:
- name: default
  driver: dir
profiles:
- name: default
  description: "Default LXD profile"
  devices:
    eth0:
      name: eth0
      network: lxdbr0
      type: nic
cluster: null
EOF

echo "Running lxd init --preseed (non-interactive). This will create a bridge 'lxdbr0' and a dir storage pool named 'default'."
# Use the lxd (snap) binary location if needed; lxd init uses the running daemon
lxd init --preseed < "${PRESEED_FILE}"

echo "LXD initialized. Run 'lxc network list' and 'lxc storage list' to verify."
