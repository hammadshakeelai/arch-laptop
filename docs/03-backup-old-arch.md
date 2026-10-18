# Pre-Reinstall Salvage & Backup Guide

Before formatting the disk, you should run the automated backup script or manually copy the irreplaceable files from your current Arch installation.

---

## 1. Automated One-Command Backup

On your current Arch laptop, clone this repository or download [backup_old_arch.sh](file:///c:/Users/HP/Documents/GitHub/arch-laptop/scripts/backup_old_arch.sh) and execute:

```bash
chmod +x scripts/backup_old_arch.sh
sudo ./scripts/backup_old_arch.sh
```

This creates a timestamped archive: `~/arch_preinstall_backup_TIMESTAMP.tar.gz` and dumps your VM image to an external USB drive or secondary path.

---

## 2. Essential Assets Checklist

| Asset | Source Path on Old Arch | Purpose |
| :--- | :--- | :--- |
| **QEMU VM XML** | `virsh dumpxml ubuntu-vm` | Exact CPU, RAM, network, disk bindings for your Ubuntu VM |
| **QEMU VM Disk** | `/var/lib/libvirt/images/ubuntu-vm.qcow2` | The entire virtual hard drive of your Ubuntu VM |
| **Jupyter Cling Script** | `~/` or workspace `.sh` files | Custom script setting up Cling C++ Jupyter kernel in VS Code |
| **Claude Science Plugin** | `~/.gemini/config/plugins/science/` or `~/.claude/` | Scientific MCP tools, structure viewer, API credentials |
| **Assembly & DOSBox** | `~/.dosbox/`, `~/assembly/`, `afd.exe`, `nasm` files | 8086 assembly projects, debuggers, DOSBox configurations |
| **GNOME Customizations** | `dconf dump / > dconf-settings.ini` | Window positions, shortcuts, extensions, keybindings |
| **Package Manifests** | `pacman -Qqe` & `pacman -Qqm` | Complete list of all native and AUR packages you had installed |
| **SSH & Git Config** | `~/.ssh/`, `~/.gitconfig` | SSH keys, GitHub access, Git authorship identity |
| **Tailscale State** | `/var/lib/tailscale/tailscaled.state` | Preserves the machine's exact Tailscale IP (`100.98.133.25`) |

---

## 3. Manual Step-by-Step Salvage Commands

If running manually in a terminal:

### A. QEMU / KVM Virtual Machine
```bash
# Export the hardware topology:
virsh dumpxml ubuntu-vm > ~/ubuntu-vm.xml

# Copy the disk image to external storage (e.g. /run/media/hammad/USB/):
sudo cp /var/lib/libvirt/images/ubuntu-vm.qcow2 /run/media/hammad/USB/
```

### B. GNOME Desktop & Shortcuts
```bash
# Export all GNOME settings (shortcuts, themes, dock, extensions):
dconf dump / > ~/gnome-full-backup.dconf
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > ~/gnome-shortcuts.dconf
```

### C. Installed Packages Manifest
```bash
# Native pacman packages:
pacman -Qqe > ~/pkglist-native.txt

# AUR packages:
pacman -Qqm > ~/pkglist-aur.txt
```

### D. Locate and Save Jupyter Cling Scripts
```bash
# Find any cling or jupyter scripts in home directory:
find ~ -maxdepth 4 -name "*cling*" -o -name "*jupyter*.sh" -o -name "*xeus*" 2>/dev/null
```
