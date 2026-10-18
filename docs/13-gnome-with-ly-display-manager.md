# Configuring GNOME (Wayland) with the `ly` TUI Display Manager

Choosing **`ly`** as your display manager provides an ultra-fast, lightweight text-mode (TUI) matrix/terminal login experience while keeping system memory usage close to zero before your desktop launches.

However, because GNOME's native ecosystem assumes **GDM**, using `ly` requires three specific configurations for seamless operation:
1. **PAM configuration** for automatic GNOME Keyring unlock.
2. **Screen locking** integration on Wayland.
3. **Session environment & portals** verification.

---

## 1. Automatic GNOME Keyring Unlock (PAM Setup)

Without this, every time you open VS Code, Chromium, or connect to Wi-Fi, GNOME prompts: *"Enter password to unlock your login keyring"*.

### Configuration
Edit `/etc/pam.d/ly`:

```bash
sudo nvim /etc/pam.d/ly
```

Update `/etc/pam.d/ly` to include `pam_gnome_keyring.so`:

```pam
#%PAM-1.0

auth       include      system-login
auth       optional     pam_gnome_keyring.so

account    include      system-login

password   include      system-login
password   optional     pam_gnome_keyring.so use_authtok

session    include      system-login
session    optional     pam_gnome_keyring.so auto_start
```

### Enable Keyring Daemon
Ensure `gnome-keyring` is installed:
```bash
sudo pacman -S --needed gnome-keyring
```

When you log into `ly` with your user password, PAM automatically passes that password to decrypt your login keyring in the background!

---

## 2. Screen Locking on Wayland (`Super + L`)

When GDM is not running, GNOME's built-in lock screen may not receive the standard session lock signal. You have two rock-solid options:

### Option A: `gtklock` (Recommended - Looks Native to GNOME)
`gtklock` is built with GTK3/GTK4 specifically for Wayland. It matches GNOME's aesthetic, supports PAM authentication, and displays battery, time, and media controls.

1. Install `gtklock` via AUR:
   ```bash
   yay -S --needed gtklock
   ```

2. Bind `Super + L` to `gtklock`:
   ```bash
   gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l']"
   ```
   Or create a custom shortcut in GNOME Settings -> Keyboard -> Custom Shortcuts:
   - **Name**: Lock Screen
   - **Command**: `gtklock -d`
   - **Shortcut**: `Super + L`

### Option B: `swaylock-effects` (Minimalist Blurred Desktop)
1. Install `swaylock-effects`:
   ```bash
   yay -S --needed swaylock-effects-git
   ```
2. Command to run:
   ```bash
   swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --grace 2 --fade-in 0.2
   ```

### Locking Automatically on Suspend / Lid Close
Create a systemd lock service before sleep:

```bash
sudo tee /etc/systemd/system/lock-before-suspend@.service <<EOF
[Unit]
Description=Lock screen before suspend
Before=sleep.target

[Service]
User=%I
Type=forking
Environment=XDG_SESSION_TYPE=wayland
ExecStart=/usr/bin/gtklock -d

[Install]
WantedBy=sleep.target
EOF

sudo systemctl enable lock-before-suspend@hammad.service
```

---

## 3. Session Stability & Desktop Portals

To ensure Wayland screen sharing, dark mode switching, and file pickers work properly without GDM:

1. Ensure the portal packages are present:
   ```bash
   sudo pacman -S --needed xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk
   ```

2. Verify systemd user session management:
   In `/etc/ly/config.ini`:
   ```ini
   # Ensure wayland sessions are enabled:
   wayland_cmd = /usr/bin/gnome-session
   ```

3. Enable `ly` systemd service:
   ```bash
   sudo systemctl disable gdm.service 2>/dev/null || true
   sudo systemctl enable ly.service
   ```
