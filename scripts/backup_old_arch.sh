#!/usr/bin/env bash
# ==============================================================================
# backup_old_arch.sh
# Automated backup script for Arch Linux laptop before clean re-installation.
# ==============================================================================

set -euo pipefail

BACKUP_DIR="${HOME}/arch_preinstall_backup_$(date +%Y%m%d_%H%M%S)"
echo "===> Creating backup staging directory: ${BACKUP_DIR}"
mkdir -p "${BACKUP_DIR}/configs"
mkdir -p "${BACKUP_DIR}/vm"
mkdir -p "${BACKUP_DIR}/scripts"
mkdir -p "${BACKUP_DIR}/packages"

# 1. Export GNOME Desktop Configurations & Shortcuts
if command -v dconf &>/dev/null; then
    echo "===> Exporting GNOME settings and keybindings via dconf..."
    dconf dump / > "${BACKUP_DIR}/configs/gnome_full.dconf" || true
    dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > "${BACKUP_DIR}/configs/gnome_shortcuts.dconf" || true
    dconf dump /org/gnome/shell/extensions/dash-to-dock/ > "${BACKUP_DIR}/configs/dash_to_dock.dconf" || true
fi

# 2. Export Installed Packages
echo "===> Saving installed package lists..."
pacman -Qqe > "${BACKUP_DIR}/packages/pacman_explicit.txt" 2>/dev/null || true
pacman -Qqm > "${BACKUP_DIR}/packages/aur_packages.txt" 2>/dev/null || true

# 3. Export QEMU / KVM Virtual Machine Configuration
if command -v virsh &>/dev/null; then
    echo "===> Checking for libvirt VMs..."
    for vm in $(virsh -c qemu:///system list --name --all 2>/dev/null); do
        if [ -n "$vm" ]; then
            echo "   Dumping XML for VM: $vm"
            virsh -c qemu:///system dumpxml "$vm" > "${BACKUP_DIR}/vm/${vm}.xml" || true
        fi
    done
fi

# 4. Search for Jupyter Cling and custom shell scripts
echo "===> Searching for custom C++ / Cling / Jupyter / DOSBox scripts in $HOME..."
find "$HOME" -maxdepth 4 \( -name "*cling*" -o -name "*xeus*" -o -name "*jupyter*.sh" -o -name "*dosbox*.conf" -o -name "*afd*" \) \
    -not -path "*/.*/*" -not -path "*/cache/*" \
    -exec cp --parents -t "${BACKUP_DIR}/scripts/" {} + 2>/dev/null || true

# 5. Backup Dotfiles & Tool Configurations
echo "===> Copying dotfiles and configuration directories..."
[ -d "$HOME/.ssh" ] && cp -r "$HOME/.ssh" "${BACKUP_DIR}/configs/ssh_backup"
[ -d "$HOME/.config/VSCodium" ] && cp -r "$HOME/.config/VSCodium" "${BACKUP_DIR}/configs/vscodium_config" || true
[ -d "$HOME/.config/Code" ] && cp -r "$HOME/.config/Code" "${BACKUP_DIR}/configs/code_config" || true
[ -d "$HOME/.gemini" ] && cp -r "$HOME/.gemini" "${BACKUP_DIR}/configs/gemini_backup" || true
[ -d "$HOME/.claude" ] && cp -r "$HOME/.claude" "${BACKUP_DIR}/configs/claude_backup" || true
[ -f "$HOME/.gitconfig" ] && cp "$HOME/.gitconfig" "${BACKUP_DIR}/configs/gitconfig" || true
[ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "${BACKUP_DIR}/configs/bashrc" || true
[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "${BACKUP_DIR}/configs/zshrc" || true

# 6. Backup Tailscale Node State (Preserves Tailscale IP)
if [ -d "/var/lib/tailscale" ]; then
    echo "===> Backing up Tailscale state file (requires sudo)..."
    sudo cp /var/lib/tailscale/tailscaled.state "${BACKUP_DIR}/configs/tailscaled.state" 2>/dev/null || true
fi

# 7. Create Consolidated Tarball
ARCHIVE="${HOME}/arch_backup_ready.tar.gz"
echo "===> Compressing backup into: ${ARCHIVE}"
tar -czf "${ARCHIVE}" -C "${HOME}" "$(basename "${BACKUP_DIR}")"

echo ""
echo "=========================================================================="
echo " [SUCCESS] Backup complete!"
echo " 1. Archive saved to: ${ARCHIVE}"
echo " 2. VM DISK NOTICE: Remember to copy your VM disk images manually!"
echo "    Location: /var/lib/libvirt/images/ (e.g. ubuntu-vm.qcow2)"
echo "    Copy to external USB: sudo cp /var/lib/libvirt/images/*.qcow2 /media/USB/"
echo "=========================================================================="
