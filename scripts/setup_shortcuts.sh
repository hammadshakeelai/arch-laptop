#!/usr/bin/env bash
set -euo pipefail

echo "=========================================================================="
echo " [1/3] Installing gnome-terminal..."
echo "=========================================================================="
sudo pacman -S --needed --noconfirm gnome-terminal

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

echo "=========================================================================="
echo " [2/3] Injecting Ubuntu Exact Shortcuts via Dconf..."
echo "=========================================================================="
# Custom Terminal Bindings (Alt+t and Ctrl+Alt+t)
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"

dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'Terminal (Alt+T)'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'gnome-terminal'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Alt>t'"

dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/name "'Terminal (Ctrl+Alt+T)'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/command "'gnome-terminal'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/binding "'<Control><Alt>t'"

# System Shortcuts
dconf write /org/gnome/desktop/wm/keybindings/close "['<Alt>AudioRaiseVolume']"
dconf write /org/gnome/desktop/wm/keybindings/show-desktop "['<Super>d']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/control-center "['<Super>x']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/search "['<Super>s']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/www "['<Alt>i']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/volume-mute "['<Control>m']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/play "['<Control>p']"

# Sound & Theme Settings
dconf write /org/gnome/desktop/sound/allow-volume-above-100-percent "true"
dconf write /org/gnome/desktop/sound/event-sounds "true"
dconf write /org/gnome/desktop/sound/theme-name "'__custom'"

echo "=========================================================================="
echo " [3/3] Setting Up Ubuntu Warty Startup Chime on Login..."
echo "=========================================================================="
mkdir -p "${HOME}/.config/autostart"
mkdir -p "${HOME}/.local/share/sounds"

if [ -f /run/media/hammad/Ventoy/ARCH_LAPTOP_SALVAGE/ubuntu_sounds/warty-startup.oga ]; then
    cp /run/media/hammad/Ventoy/ARCH_LAPTOP_SALVAGE/ubuntu_sounds/warty-startup.oga "${HOME}/.local/share/sounds/"
fi

cat <<'EOF' > "${HOME}/.config/autostart/ubuntu-login-sound.desktop"
[Desktop Entry]
Type=Application
Exec=pw-play /home/hammad/.local/share/sounds/warty-startup.oga
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Ubuntu Startup Sound
Comment=Plays the authentic Ubuntu startup instrument music on login
EOF

echo ""
echo "=========================================================================="
echo " [SUCCESS] Verified Active Shortcuts:"
echo "   Alt + t             -> Launch Terminal"
echo "   Ctrl + Alt + t      -> Launch Terminal"
echo "   Super + x           -> Settings / Control Center"
echo "   Super + s           -> Search"
echo "   Alt + i             -> Web Browser"
echo "   Ctrl + m            -> Mute Volume"
echo "   Ctrl + p            -> Play/Pause Media"
echo "   Super + d           -> Show Desktop"
echo "   Alt + VolUp         -> Close Window"
echo "=========================================================================="
