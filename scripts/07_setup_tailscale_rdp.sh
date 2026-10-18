#!/usr/bin/env bash
# ==============================================================================
# 07_setup_tailscale_rdp.sh
# Sets up Tailscale mesh networking and native GNOME Remote Desktop (RDP).
# ==============================================================================

set -euo pipefail

echo "=========================================================================="
echo " [1/3] Installing Tailscale & GNOME Remote Desktop..."
echo "=========================================================================="
sudo pacman -S --needed --noconfirm tailscale gnome-remote-desktop

echo "=========================================================================="
echo " [2/3] Enabling Tailscale Service..."
echo "=========================================================================="
sudo systemctl enable --now tailscaled.service

# Check if backed up state exists
if [ -f "${HOME}/arch_backup_ready/configs/tailscaled.state" ]; then
    echo "   Restoring previous Tailscale identity..."
    sudo systemctl stop tailscaled
    sudo cp "${HOME}/arch_backup_ready/configs/tailscaled.state" /var/lib/tailscale/tailscaled.state
    sudo systemctl start tailscaled
else
    echo "   Starting fresh authentication (run 'sudo tailscale up --ssh' if needed)..."
    sudo tailscale up --ssh || true
fi

echo "=========================================================================="
echo " [3/3] Configuring GNOME Remote Desktop..."
echo "=========================================================================="
grdctl rdp enable || true
grdctl rdp enable-remote-login || true

echo ""
echo "=========================================================================="
echo " [SUCCESS] Tailscale & Remote Desktop installed!"
echo " Tailscale IP: $(tailscale ip -4 2>/dev/null || echo 'Run sudo tailscale up')"
echo ""
echo " To set your RDP password, run:"
echo "   grdctl rdp set-credentials $USER <your-password>"
echo " Connect from Windows via 'mstsc' using the Tailscale IP."
echo "=========================================================================="
