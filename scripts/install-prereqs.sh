#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root: sudo $0"
  exit 1
fi

# Basic package update and virtualization packages (Ubuntu/Debian)
apt update
apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils cpu-checker cloud-image-utils

# Optional tool to check virtualization
if command -v kvm-ok >/dev/null 2>&1; then
  kvm-ok || echo "kvm-ok reported issues; check nested virtualization / BIOS settings"
else
  echo "Install cpu-checker (apt install cpu-checker) to run kvm-ok"
fi

# Ensure snapd is installed
apt install -y snapd
# Make sure core is available
snap install core || true
snap refresh core || true

# Install LXD (snap)
if ! snap list lxd >/dev/null 2>&1; then
  snap install lxd
else
  echo "lxd snap already installed"
fi

# Add current login user to groups (preserves if run with sudo)
USER_TO_ADD="$(logname 2>/dev/null || echo root)"
usermod -aG libvirt "$USER_TO_ADD" || true
usermod -aG kvm "$USER_TO_ADD" || true
usermod -aG lxd "$USER_TO_ADD" || true

# Enable/start libvirtd (for /dev/kvm and KVM management)
systemctl enable --now libvirtd || echo "libvirtd enable/start returned non-zero; check libvirt installation"

# Start snap LXD daemon
snap start lxd || echo "snap start lxd: may already be running"

echo "Prereqs installed. You should re-login for group membership to take effect (or run: newgrp lxd)."
