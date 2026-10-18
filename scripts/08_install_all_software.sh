#!/usr/bin/env bash
# ==============================================================================
# 08_install_all_software.sh
# Installs all requested applications and development tools from manifests.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "${SCRIPT_DIR}")"

PACMAN_FILE="${REPO_ROOT}/packages/pacman-packages.txt"
AUR_FILE="${REPO_ROOT}/packages/aur-packages.txt"

echo "=========================================================================="
echo " [1/2] Installing Official Packages via Pacman..."
echo "=========================================================================="
if [ -f "${PACMAN_FILE}" ]; then
    # Filter comments and empty lines
    PACKAGES=$(grep -vE '^\s*#|^\s*$' "${PACMAN_FILE}" | tr '\n' ' ')
    echo "Installing: ${PACKAGES}"
    sudo pacman -S --needed --noconfirm ${PACKAGES}
fi

echo "=========================================================================="
echo " [2/2] Installing AUR Packages via YAY (OnlyOffice, VSCodium, Spotify, etc.)..."
echo "=========================================================================="
if [ -f "${AUR_FILE}" ]; then
    AUR_PACKAGES=$(grep -vE '^\s*#|^\s*$' "${AUR_FILE}" | tr '\n' ' ')
    echo "Installing: ${AUR_PACKAGES}"
    yay -S --needed --noconfirm ${AUR_PACKAGES}
fi

echo ""
echo "=========================================================================="
echo " [SUCCESS] All applications and productivity tools installed!"
echo "=========================================================================="
