import subprocess

# Set custom keybindings back to custom0 (Alt+T) and custom1 (Ctrl+Alt+T), removing custom2 (gtklock)
subprocess.run([
    "gsettings", "set", "org.gnome.settings-daemon.plugins.media-keys",
    "custom-keybindings",
    "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
])

# Ensure screensaver shortcut is Super + L
subprocess.run([
    "gsettings", "set", "org.gnome.settings-daemon.plugins.media-keys",
    "screensaver",
    "['<Super>l']"
])

print("Shortcuts updated:")
res1 = subprocess.run(["gsettings", "get", "org.gnome.settings-daemon.plugins.media-keys", "custom-keybindings"], capture_output=True, text=True)
res2 = subprocess.run(["gsettings", "get", "org.gnome.settings-daemon.plugins.media-keys", "screensaver"], capture_output=True, text=True)
print("Custom:", res1.stdout.strip())
print("Screensaver:", res2.stdout.strip())
