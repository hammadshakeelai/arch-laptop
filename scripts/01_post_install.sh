#!/usr/bin/env bash
# ==============================================================================
# 01_post_install.sh
# Post-installation script: Audio, YAY (AUR Helper), Base Development, ZRAM
# Run this script immediately after your first boot into the new Arch install.
# ==============================================================================

set -euo pipefail

if [ "$EUID" -eq 0 ]; then
    echo "ERROR: Do not run this script as root! Run as your normal user (e.g. hammad)."
    exit 1
fi

echo "=========================================================================="
echo " [1/5] Updating System Packages..."
echo "=========================================================================="
sudo pacman -Syu --noconfirm

echo "=========================================================================="
echo " [2/5] Installing Core Development Tools & Git..."
echo "=========================================================================="
sudo pacman -S --needed --noconfirm base-devel git wget curl unzip neovim

echo "=========================================================================="
echo " [3/5] Installing and Enabling PipeWire Audio Stack..."
echo "=========================================================================="
sudo pacman -S --needed --noconfirm pipewire pipewire-pulse pipewire-alsa wireplumber
systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service

echo "=========================================================================="
echo " [4/5] Installing YAY (Arch User Repository Helper)..."
echo "=========================================================================="
if ! command -v yay &>/dev/null; then
    echo "Building yay from AUR..."
    TEMP_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "${TEMP_DIR}/yay-bin"
    cd "${TEMP_DIR}/yay-bin"
    makepkg -si --noconfirm
    cd -
    rm -rf "${TEMP_DIR}"
fi
echo "YAY installed successfully: $(yay --version)"

echo "=========================================================================="
echo " [5/5] Detecting CPU Microcode..."
echo "=========================================================================="
if grep -q "GenuineIntel" /proc/cpuinfo; then
    echo "Intel CPU detected. Installing intel-ucode..."
    sudo pacman -S --needed --noconfirm intel-ucode
elif grep -q "AuthenticAMD" /proc/cpuinfo; then
    echo "AMD CPU detected. Installing amd-ucode..."
    sudo pacman -S --needed --noconfirm amd-ucode
fi

echo ""
echo "=========================================================================="
echo " [SUCCESS] Post-install core setup is complete!"
echo " Next step: Run scripts/02_setup_theming_and_sound.sh"
echo "=========================================================================="
