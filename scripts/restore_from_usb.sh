#!/usr/bin/env bash
set -euo pipefail

SALVAGE="/run/media/hammad/Ventoy/ARCH_LAPTOP_SALVAGE"

if [ ! -d "$SALVAGE" ]; then
    echo "ERROR: $SALVAGE does not exist! Make sure Ventoy USB is mounted."
    exit 1
fi

echo "=========================================================================="
echo " [1/6] Restoring University IMS, Coursework, Notebooks, ASM..."
echo "=========================================================================="
cp -r "${SALVAGE}/University IMS" /home/hammad/
cp -r "${SALVAGE}/ubuntu_coursework/"* /home/hammad/
cp -r "${SALVAGE}/notebooks" /home/hammad/
cp -r "${SALVAGE}/asm_workspace" /home/hammad/
echo "Coursework restored successfully."

echo "=========================================================================="
echo " [2/6] Restoring Ubuntu Wallpapers and Sounds..."
echo "=========================================================================="
mkdir -p /home/hammad/Pictures /home/hammad/.local/share/sounds
cp -r "${SALVAGE}/ubuntu_wallpapers/"* /home/hammad/Pictures/ 2>/dev/null || true
cp -r "${SALVAGE}/ubuntu_sounds/"* /home/hammad/.local/share/sounds/ 2>/dev/null || true
echo "Wallpapers and sounds restored."

echo "=========================================================================="
echo " [3/6] Restoring Tailscale Cryptographic Node State..."
echo "=========================================================================="
if [ -f "${SALVAGE}/tailscaled.state" ]; then
    sudo mkdir -p /var/lib/tailscale
    sudo cp "${SALVAGE}/tailscaled.state" /var/lib/tailscale/
    sudo chmod 600 /var/lib/tailscale/tailscaled.state
    echo "Tailscale node state preserved (Tailscale IP 100.98.133.25)."
fi

echo "=========================================================================="
echo " [4/6] Restoring Claude Science Suite (2.6GB)..."
echo "=========================================================================="
if [ -f "${SALVAGE}/claude-science.tar.gz" ]; then
    tar -xzf "${SALVAGE}/claude-science.tar.gz" -C /home/hammad/
    echo "Claude Science suite unpacked."
fi

echo "=========================================================================="
echo " [5/6] Restoring Configs and Dotfiles..."
echo "=========================================================================="
if [ -f "${SALVAGE}/dotfiles_and_configs.tar.gz" ]; then
    tar -xzf "${SALVAGE}/dotfiles_and_configs.tar.gz" -C /home/hammad/
    echo "Dotfiles and configs unpacked."
fi

echo "=========================================================================="
echo " [6/6] Ensuring correct permissions..."
echo "=========================================================================="
sudo chown -R hammad:hammad /home/hammad/

echo ""
echo "=========================================================================="
echo " [SUCCESS] 100% of user data restored from Ventoy USB!"
echo "=========================================================================="
