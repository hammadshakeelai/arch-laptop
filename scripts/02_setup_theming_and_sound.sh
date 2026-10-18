#!/usr/bin/env bash
# ==============================================================================
# 02_setup_theming_and_sound.sh
# Configures exact Ubuntu look & feel extracted from your authentic Ubuntu install.
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
echo " [3/5] Applying Authentic Ubuntu Desktop Theming & Colors..."
echo "=========================================================================="
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru'
gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
gsettings set org.gnome.desktop.sound theme-name 'Yaru'

echo "=========================================================================="
echo " [4/5] Applying Authentic Ubuntu Bottom Dock Settings..."
echo "=========================================================================="
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 56
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'cycle-or-minimize'
gsettings set org.gnome.shell.extensions.dash-to-dock isolate-monitors true
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true

echo "=========================================================================="
echo " [5/5] Applying Authentic Ubuntu Shortcuts & Startup Login Music..."
echo "=========================================================================="
# Ubuntu specific keybindings extracted from your machine
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Alt>t']" || true
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>x']" || true
gsettings set org.gnome.settings-daemon.plugins.media-keys search "['<Super>s']" || true
gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Alt>i']" || true
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-mute "['<Control>m']" || true
gsettings set org.gnome.settings-daemon.plugins.media-keys play "['<Control>p']" || true

# Ubuntu login instrumental music autostart (warty-startup or desktop-login)
mkdir -p "${HOME}/.config/autostart"
cat <<EOF > "${HOME}/.config/autostart/ubuntu-login-sound.desktop"
[Desktop Entry]
Type=Application
Exec=pw-play /usr/share/sounds/Yaru/stereo/desktop-login.oga
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Ubuntu Startup Sound
Comment=Plays the authentic Ubuntu startup instrument music on login
EOF

echo ""
echo "=========================================================================="
echo " [SUCCESS] Ubuntu theming, dock, shortcuts, and bootup sound configured!"
echo "=========================================================================="
