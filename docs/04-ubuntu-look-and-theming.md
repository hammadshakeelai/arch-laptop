# Replicating the Ubuntu Look, Feel, and Desktop Experience on Arch

You can configure Arch Linux running GNOME to look and behave identically to an authentic Ubuntu desktop while enjoying the speed, clean base, and AUR of Arch Linux.

---

## 1. Components Required

| Component | Ubuntu Equivalent | Package on Arch |
| :--- | :--- | :--- |
| **Desktop Environment** | GNOME Shell | `gnome`, `gnome-tweaks`, `extension-manager` |
| **The Dock** | Ubuntu Dock | `gnome-shell-extension-dash-to-dock` |
| **GTK Application Theme** | Yaru GTK (Dark/Light) | `yaru-gtk-theme` (AUR) |
| **Icon Theme** | Yaru Icons (Aubergine/Orange) | `yaru-icon-theme` (AUR) |
| **Cursor Theme** | Yaru Cursor | `yaru-icon-theme` (AUR) |
| **Sound Theme** | Yaru Sounds & Login Chord | `yaru-sound-theme` (AUR) |
| **Shell Theme** | Ubuntu Dark Shell | `user-themes` extension + Yaru Shell |

---

## 2. Installation via Pacman & Yay

```bash
# 1. Base GNOME and Tweaks:
sudo pacman -S --needed gnome gnome-tweaks gnome-shell-extension-dash-to-dock extension-manager

# 2. Ubuntu Yaru Themes from AUR:
yay -S --needed yaru-gtk-theme yaru-icon-theme yaru-sound-theme
```

---

## 3. Configuring the Centered Bottom Dock

In modern Ubuntu, the dock can be centered at the bottom as a clean floating dock (or full-width panel). To achieve the centered floating dock shown in your setup:

### Using GNOME Extension Manager or CLI:
Run the following `gsettings` commands to automatically configure Dash to Dock:

```bash
# Set dock position to BOTTOM:
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'

# Disable extending to screen edge (centers the dock!):
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false

# Set icon size to clean 48px:
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48

# Enable autohide or intelligent hide:
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true

# Enable click action to cycle-or-minimize:
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'cycle-or-minimize'
```

---

## 4. Applying the Yaru Theme (Ubuntu Aesthetics)

Apply the authentic Ubuntu theme using `gsettings`:

```bash
# Set GTK Theme:
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'

# Set Color Scheme to Dark:
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Set Icon Theme:
gsettings set org.gnome.desktop.interface icon-theme 'Yaru'

# Set Cursor Theme:
gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'

# Set Sound Theme:
gsettings set org.gnome.desktop.sound theme-name 'Yaru'
```

---

## 5. Setting Ubuntu Keyboard Shortcuts

By default, Ubuntu configures `Ctrl+Alt+T` to open a terminal, and uses Super-key combinations.

To load the authentic Ubuntu shortcut bindings on Arch:

```bash
# Enable Ctrl+Alt+T to launch Terminal:
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Primary><Alt>t']"

# Enable Super+E to open Files:
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"

# Enable Super+1 through Super+9 for dock app launching:
gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys true
```

Or load the complete pre-configured shortcut file from this repo:
```bash
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < configs/ubuntu_shortcuts.dconf
```
