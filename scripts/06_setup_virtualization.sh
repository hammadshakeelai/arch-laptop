#!/usr/bin/env bash
# ==============================================================================
# 06_setup_virtualization.sh
# Installs QEMU/KVM, libvirt, virt-manager, and configures user permissions.
# ==============================================================================

set -euo pipefail

echo "=========================================================================="
echo " [1/3] Installing QEMU, KVM, Libvirt, and Virt-Manager..."
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
echo " [2/3] Adding current user ($USER) to libvirt and kvm groups..."
echo "=========================================================================="
sudo usermod -aG libvirt,kvm "$USER"

echo "=========================================================================="
echo " [3/3] Enabling libvirtd service and default NAT network..."
echo "=========================================================================="
sudo systemctl enable --now libvirtd.service

# Configure default network
sudo virsh net-autostart default || true
sudo virsh net-start default || true

echo ""
echo "=========================================================================="
echo " [SUCCESS] Virtualization stack is active!"
echo " Restoring a VM:"
echo "   1. Copy .qcow2 to /var/lib/libvirt/images/"
echo "   2. Run: virsh define <vm_name>.xml"
echo "   3. Launch 'virt-manager'"
echo "=========================================================================="
