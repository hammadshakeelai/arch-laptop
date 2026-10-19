#!/usr/bin/env bash
set -euo pipefail

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

echo "=========================================================================="
echo " [1/7] Configuring Laptop Lid Settings (DO NOT SLEEP ON LID CLOSE)..."
echo "=========================================================================="
sudo tee -a /etc/systemd/logind.conf.d/ignore-lid.conf <<'EOF' >/dev/null
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
LidSwitchIgnoreInhibited=no
EOF
sudo systemctl kill -s HUP systemd-logind || true

gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing' || true
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing' || true

echo "=========================================================================="
echo " [2/7] Binding Super+L to gtklock Screen Locker..."
echo "=========================================================================="
# Configure Super+L custom shortcut
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/name "'Lock Screen (gtklock)'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/command "'gtklock -d'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/binding "'<Super>l'"

# Update list of custom keybindings
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"

echo "=========================================================================="
echo " [3/7] Restoring Authentic Ubuntu Wallpaper..."
echo "=========================================================================="
sudo mkdir -p /usr/share/backgrounds
sudo cp /home/hammad/Pictures/*.webp /usr/share/backgrounds/ 2>/dev/null || true
sudo cp /home/hammad/Pictures/*.png /usr/share/backgrounds/ 2>/dev/null || true

gsettings set org.gnome.desktop.background picture-uri 'file:///home/hammad/Pictures/moskalenko-v-Snowy_Ubuntu_Light.webp' || true
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///home/hammad/Pictures/moskalenko-v-Snowy_Ubuntu_Dark.webp' || true
gsettings set org.gnome.desktop.background picture-options 'zoom' || true

echo "=========================================================================="
echo " [4/7] Installing Neovim, Chromium, Python IPykernel, Pip..."
echo "=========================================================================="
sudo pacman -S --needed --noconfirm neovim chromium python-pip python-ipykernel python-virtualenv ollama

echo "=========================================================================="
echo " [5/7] Installing VS Code Python & Jupyter Environment..."
echo "=========================================================================="
python -m ipykernel install --user --name python3 --display-name "Python 3" || true

code --install-extension ms-python.python --force || true
code --install-extension ms-toolsai.jupyter --force || true
code --install-extension ms-toolsai.jupyter-renderers --force || true

echo "=========================================================================="
echo " [6/7] Enabling Ollama Local LLM Engine & pulling abliterated model..."
echo "=========================================================================="
sudo systemctl enable --now ollama.service || true

echo "=========================================================================="
echo " [7/7] Installing Google Chrome & Claude-Code from AUR..."
echo "=========================================================================="
yay -S --needed --noconfirm google-chrome ya-claude-code || true

echo ""
echo "=========================================================================="
echo " [SUCCESS] All requested items configured!"
echo "=========================================================================="
