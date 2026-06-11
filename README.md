# lxd-vm-setup

This repository provides scripts to install and configure LXD with VM support (--vm) on an Ubuntu/Debian host, and an example to launch a VM that runs systemd.

Warning and prerequisites
- Tested on Ubuntu 22.04 / 24.04 (Debian derivatives). If you're on a different distro, tell me and I'll adapt scripts.
- Host must support virtualization (VT-x/AMD-V) and provide /dev/kvm. Check with `egrep -c '(vmx|svm)' /proc/cpuinfo` (non-zero expected) and `sudo kvm-ok` (kvm-ok from cpu-checker package).
- These scripts require sudo/root.
- Running LXD VMs on some cloud or nested VMs may require enabling nested virtualization.

Quick steps
1. Make scripts executable:
   sudo chmod +x scripts/*.sh
2. Install prerequisites (run as root):
   sudo ./scripts/install-prereqs.sh
   - Re-login or `newgrp lxd` to pick up the `lxd` group membership.
3. Initialize LXD non-interactively:
   sudo ./scripts/init-lxd.sh
4. Launch a test VM:
   ./scripts/launch-vm.sh testvm

Files included
- scripts/install-prereqs.sh — installs qemu, libvirt, snapd and the LXD snap; adds groups.
- scripts/init-lxd.sh — lxd preseed to create lxdbr0 and a dir storage pool (works without zfs).
- scripts/launch-vm.sh — launches an Ubuntu VM using `lxc launch --vm`.
- cloud-init/user-data.yaml — sample cloud-init for the VM.

Notes & troubleshooting
- If you prefer ZFS for storage, install zfsutils and change the preseed storage driver to `zfs`.
- On fresh systems you may need to `newgrp lxd` or log out/in after `usermod -aG lxd $USER`.
- To debug: `sudo journalctl -u snap.lxd.daemon -f` and `lxc info --show-log <vm-name>`.
- LXD images remote: examples use `images:` remote (official image server). You can mirror images to `local:` if you want.

If you want, I can:
- Change the storage backend to ZFS or LVM.
- Add a GitHub Actions CI job that runs lint/checks.
