#!/usr/bin/env bash
# ==============================================================================
# 09_setup_ly_gnome.sh
# Fixes GNOME Keyring auto-unlock and Wayland screen locking when using 'ly'.
# ==============================================================================

set -euo pipefail

echo "=========================================================================="
echo " [1/4] Installing GNOME Keyring & Desktop Portals..."
echo "=========================================================================="
sudo pacman -S --needed --noconfirm gnome-keyring xdg-desktop-portal xdg-desktop-portal-gnome

echo "=========================================================================="
echo " [2/4] Updating /etc/pam.d/ly for automatic Keyring unlocking..."
echo "=========================================================================="
if [ -f /etc/pam.d/ly ]; then
    # Backup existing PAM configuration
    sudo cp /etc/pam.d/ly /etc/pam.d/ly.bak-$(date +%Y%m%d)

    sudo tee /etc/pam.d/ly > /dev/null <<'EOF'
#%PAM-1.0

auth       include      system-login
auth       optional     pam_gnome_keyring.so

account    include      system-login

password   include      system-login
password   optional     pam_gnome_keyring.so use_authtok

session    include      system-login
session    optional     pam_gnome_keyring.so auto_start
EOF
    echo "PAM configuration updated successfully."
else
    echo "NOTICE: /etc/pam.d/ly does not exist yet. Please install 'ly' first."
fi

echo "=========================================================================="
echo " [3/4] Installing and Configuring GTK-based Wayland Screen Locker..."
echo "=========================================================================="
if command -v yay &>/dev/null; then
    yay -S --needed --noconfirm gtklock
fi

# Configure Super + L shortcut
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l']" || true

echo "=========================================================================="
echo " [4/4] Setting up automatic lock before suspend/lid close..."
echo "=========================================================================="
sudo tee /etc/systemd/system/lock-before-suspend@.service > /dev/null <<'EOF'
[Unit]
Description=Lock screen before suspend (Wayland / gtklock)
Before=sleep.target

[Service]
User=%I
Type=forking
Environment=XDG_SESSION_TYPE=wayland
ExecStart=/usr/bin/gtklock -d

[Install]
WantedBy=sleep.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable "lock-before-suspend@${USER}.service" || true

echo ""
echo "=========================================================================="
echo " [SUCCESS] GNOME + ly integration complete!"
echo " 1. GNOME Keyring will unlock automatically on login."
echo " 2. Super + L will lock the screen using gtklock."
echo " 3. The laptop will lock automatically when the lid closes."
echo "=========================================================================="
