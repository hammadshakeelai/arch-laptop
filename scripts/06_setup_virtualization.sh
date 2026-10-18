#!/usr/bin/env bash
# ==============================================================================
# 06_setup_virtualization.sh
# Installs QEMU/KVM, libvirt, virt-manager, and restores your Ubuntu VM.
# ==============================================================================

set -euo pipefail

echo "=========================================================================="
echo " [1/4] Installing QEMU, KVM, Libvirt, and Virt-Manager..."
echo "=========================================================================="
sudo pacman -S --needed --noconfirm \
    qemu-full \
    libvirt \
    virt-manager \
    virt-viewer \
    dnsmasq \
    iptables-nft \
    dmidecode \
    bridge-utils

echo "=========================================================================="
echo " [2/4] Adding current user ($USER) to libvirt and kvm groups..."
echo "=========================================================================="
sudo usermod -aG libvirt,kvm "$USER"

echo "=========================================================================="
echo " [3/4] Enabling libvirtd service and default NAT network..."
echo "=========================================================================="
sudo systemctl enable --now libvirtd.service

sudo virsh net-autostart default || true
sudo virsh net-start default || true

echo "=========================================================================="
echo " [4/4] Restoring your Ubuntu VM from backup..."
echo "=========================================================================="
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "${SCRIPT_DIR}")"
XML_FILE="${REPO_ROOT}/configs/ubuntu-vm.xml"

# Look for the backed up qcow2 image on USB or current directory
QCOW_SRC=""
for path in \
    "/run/media/${USER}/Ventoy/ARCH_LAPTOP_SALVAGE/ubuntu-vm.qcow2" \
    "${HOME}/ubuntu-vm.qcow2" \
    "${HOME}/arch_backup_ready/ubuntu-vm.qcow2"; do
    if [ -f "$path" ]; then
        QCOW_SRC="$path"
        break
    fi
done

if [ -n "$QCOW_SRC" ]; then
    echo "Found VM disk image at: $QCOW_SRC"
    echo "Copying to /var/lib/libvirt/images/ubuntu-vm.qcow2..."
    sudo cp "$QCOW_SRC" /var/lib/libvirt/images/ubuntu-vm.qcow2
    sudo chown root:kvm /var/lib/libvirt/images/ubuntu-vm.qcow2
    sudo chmod 660 /var/lib/libvirt/images/ubuntu-vm.qcow2
else
    echo "NOTICE: Please copy your backed up ubuntu-vm.qcow2 to /var/lib/libvirt/images/ manually."
fi

if [ -f "$XML_FILE" ]; then
    echo "Defining VM from $XML_FILE..."
    sudo virsh define "$XML_FILE" || true
fi

echo ""
echo "=========================================================================="
echo " [SUCCESS] Virtualization stack is active and Ubuntu VM is restored!"
echo " Launch 'virt-manager' or run 'virsh start ubuntu-vm' to start your VM."
echo "=========================================================================="
