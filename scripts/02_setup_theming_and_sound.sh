#!/usr/bin/env bash
# ==============================================================================
# 02_setup_theming_and_sound.sh
# Configures Ubuntu Yaru themes, centered bottom dock, shortcuts, and boot music.
# ==============================================================================

set -euo pipefail

echo "=========================================================================="
echo " [1/5] Installing GNOME Tweaks, Extension Manager & Dash-to-Dock..."
echo "=========================================================================="
sudo pacman -S --needed --noconfirm gnome-tweaks extension-manager gnome-shell-extension-dash-to-dock

echo "=========================================================================="
echo " [2/5] Installing Yaru GTK, Icon, and Sound Themes from AUR..."
echo "=========================================================================="
yay -S --needed --noconfirm yaru-gtk-theme yaru-icon-theme yaru-sound-theme

echo "=========================================================================="
echo " [3/5] Applying Ubuntu Desktop Theming & Colors..."
echo "=========================================================================="
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru'
gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
gsettings set org.gnome.desktop.sound theme-name 'Yaru'

echo "=========================================================================="
echo " [4/5] Configuring Centered Bottom Dock..."
echo "=========================================================================="
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'cycle-or-minimize'

echo "=========================================================================="
echo " [5/5] Configuring Ubuntu Startup Login Music & Shortcuts..."
echo "=========================================================================="
# Autostart login sound
mkdir -p "${HOME}/.config/autostart"
cat <<EOF > "${HOME}/.config/autostart/ubuntu-login-sound.desktop"
[Desktop Entry]
Type=Application
Exec=pw-play /usr/share/sounds/yaru/stereo/desktop-login.oga
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Ubuntu Startup Sound
Comment=Plays the authentic Ubuntu startup instrument music on login
EOF

# Terminal shortcut (Ctrl+Alt+T)
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Primary><Alt>t']" || true
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']" || true

echo ""
echo "=========================================================================="
echo " [SUCCESS] Ubuntu theming, centered dock, and bootup sound are active!"
echo " Test sound now with: pw-play /usr/share/sounds/yaru/stereo/desktop-login.oga"
echo "=========================================================================="
