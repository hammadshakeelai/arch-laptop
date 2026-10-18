# Tailscale Mesh Networking & Remote Desktop (RDP) Setup

This guide details how to restore Tailscale and set up native Remote Desktop (RDP) access so you can control your Arch Linux laptop from your Windows desktop or any remote location.

---

## 1. Tailscale Installation & State Restoration

### 1.1 Install Tailscale
```bash
sudo pacman -S --needed tailscale
sudo systemctl enable --now tailscaled.service
```

### 1.2 Retaining Your Existing Tailscale IP (`100.98.133.25`)
If you backed up `tailscaled.state` from your previous installation:
```bash
sudo systemctl stop tailscaled
sudo cp /path/to/backup/tailscaled.state /var/lib/tailscale/tailscaled.state
sudo systemctl start tailscaled
```
Tailscale will immediately recognize the laptop and retain its exact previous IP address and keys without generating a duplicate machine in your admin console!

### 1.3 Fresh Authentication (if not using saved state)
```bash
sudo tailscale up --ssh
```
*(The `--ssh` flag additionally enables Tailscale SSH, allowing instant terminal login from any device on your Tailnet with `ssh 100.98.133.25` without needing SSH keys)*

---

## 2. Setting Up Remote Desktop (Native GNOME RDP)

GNOME features built-in high-performance RDP (Remote Desktop Protocol) powered by `gnome-remote-desktop`. This allows you to connect directly from Windows **Remote Desktop Connection (`mstsc`)** over Tailscale without installing third-party VNC servers.

### 2.1 Install GNOME Remote Desktop
```bash
sudo pacman -S --needed gnome-remote-desktop
```

### 2.2 Configure Credentials with `grdctl`
Run the following commands in your user session:

```bash
# Enable RDP service:
grdctl rdp enable

# Set your remote desktop username and password:
grdctl rdp set-credentials hammad "YourSecurePasswordHere"

# Enable remote login / control:
grdctl rdp enable-remote-login
```

### 2.3 Connecting from Windows
1. On your Windows PC, press `Win + R`, type `mstsc`, and press Enter.
2. In the **Computer** field, enter your laptop's Tailscale IP:
   ```
   100.98.133.25
   ```
3. Click **Connect**.
4. Enter the username (`hammad`) and password you set in `grdctl`.
5. You will instantly see your Arch Linux GNOME desktop running smoothly with full hardware acceleration!
