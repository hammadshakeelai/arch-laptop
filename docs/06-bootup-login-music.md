# Ubuntu Bootup & Login Instrumental Sound Setup

The memorable musical chime and instrumental sound when Ubuntu boots and logs in is one of its most recognizable features. On Arch Linux, you can effortlessly restore this exact audio cue.

---

## 1. Where the Ubuntu Startup Sounds Come From

When you install `yaru-sound-theme` from the AUR, the sound files are installed to `/usr/share/sounds/yaru/stereo/`:
- `desktop-login.oga` (The iconic modern Ubuntu login instrument chime)
- `system-ready.oga` (The drum/chime played when the system finishes booting to GDM)
- `bell.oga`, `message.oga`, `complete.oga`

If you want the **classic legacy Ubuntu drum/percussion chord** (from 10.04 - 14.04), it is also available or can be downloaded as an `.ogg` file.

---

## 2. Testing the Sound

Ensure your audio output is functional via PipeWire:
```bash
# Play using PipeWire:
pw-play /usr/share/sounds/yaru/stereo/desktop-login.oga

# Or using PulseAudio compatibility layer:
paplay /usr/share/sounds/yaru/stereo/desktop-login.oga
```

---

## 3. Configuring Autostart on Login

To play the instrumental sound automatically every time you log into your desktop:

### Method A: User Autostart Entry (Recommended)
Place an autostart `.desktop` file into `~/.config/autostart/`:

```bash
mkdir -p ~/.config/autostart

cat <<EOF > ~/.config/autostart/ubuntu-login-sound.desktop
[Desktop Entry]
Type=Application
Exec=pw-play /usr/share/sounds/yaru/stereo/desktop-login.oga
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Ubuntu Startup Sound
Comment=Plays the authentic Ubuntu startup instrument music on login
EOF
```

### Method B: System-Wide GDM Login Sound
If you want the music to trigger immediately when the GDM login screen appears:
```bash
sudo mkdir -p /var/lib/gdm/.config/autostart
sudo cp ~/.config/autostart/ubuntu-login-sound.desktop /var/lib/gdm/.config/autostart/
```

The script `scripts/02_setup_theming_and_sound.sh` automates this entire setup with a single command.
