# Arch Linux Laptop Setup & Migration Knowledge Base

A turnkey, production-grade blueprint and automation suite for installing, configuring, and maintaining an Arch Linux development workstation. Replicates the familiar Ubuntu aesthetics, desktop environment, and boot sound while leveraging the speed, minimal footprint, and bleeding-edge AUR ecosystem of Arch Linux.

---

## 🧭 Knowledge Base Directory

| Guide | Description | Key Focus |
| :--- | :--- | :--- |
| [01. Storage & Partitioning](file:///c:/Users/HP/Documents/GitHub/arch-laptop/docs/01-storage-and-partitioning.md) | Permanent fix for root space issues | Unified single-drive layout, Ext4 vs Btrfs, ZRAM swap |
| [02. Arch Installation Walkthrough](file:///c:/Users/HP/Documents/GitHub/arch-laptop/docs/02-arch-installation-guide.md) | Step-by-step base install guide | UEFI, `pacstrap`, locales, user setup, `systemd-boot` / GRUB |
| [03. Pre-Reinstall Salvage Guide](file:///c:/Users/HP/Documents/GitHub/arch-laptop/docs/03-backup-old-arch.md) | Backup procedures before formatting | VM export, GNOME dconf, SSH keys, dotfiles |
| [04. Ubuntu Look & Theming](file:///c:/Users/HP/Documents/GitHub/arch-laptop/docs/04-ubuntu-look-and-theming.md) | Desktop replication on GNOME | Centered bottom dock, Yaru GTK/Icons/Shell, GNOME Tweaks |
| [05. Circular Alt-Tab Switchers](file:///c:/Users/HP/Documents/GitHub/arch-laptop/docs/05-circular-alt-tab-switcher.md) | Social media "circular" window switchers | Fly-Pie radial menu, Coverflow 3D Alt-Tab, AATWS |
| [06. Bootup & Login Instrumental Music](file:///c:/Users/HP/Documents/GitHub/arch-laptop/docs/06-bootup-login-music.md) | Authentic startup chime restoration | PipeWire / PulseAudio autostart with Yaru login audio |
| [07. Jupyter C++ Cling & VS Code](file:///c:/Users/HP/Documents/GitHub/arch-laptop/docs/07-jupyter-cpp-cling-vscode.md) | Interactive C++ kernel in notebooks | Micromamba, `xeus-cling`, LLVM/Clang integration, VS Code |
| [08. Claude Science MCP Environment](file:///c:/Users/HP/Documents/GitHub/arch-laptop/docs/08-claude-science-environment.md) | Scientific tooling & Agent sidecars | Mol* 3D structure viewer, PubChem, AlphaFold, `uv` |
| [09. 8086 Assembly (DOSBox, NASM, AFD)](file:///c:/Users/HP/Documents/GitHub/arch-laptop/docs/09-dosbox-nasm-afd-setup.md) | Low-level systems programming | Real-mode 8086, NASM compilation, AFD visual debugger |
| [10. QEMU/KVM Virtual Machine Migration](file:///c:/Users/HP/Documents/GitHub/arch-laptop/docs/10-qemu-kvm-vm-migration.md) | Restoring the `ubuntu-vm` | Libvirt, Virt-Manager, `.qcow2` restoration, NAT networking |
| [11. Tailscale & Remote Desktop (RDP)](file:///c:/Users/HP/Documents/GitHub/arch-laptop/docs/11-tailscale-and-remote-desktop.md) | Remote access from Windows / mobile | Headless Tailscale mesh, native GNOME RDP (`grdctl`) |
| [12. Software Catalog (Pacman & AUR)](file:///c:/Users/HP/Documents/GitHub/arch-laptop/docs/12-software-catalog-pacman-aur.md) | Package mapping for all tools | OnlyOffice, VSCodium, Spotify, Sublime, TeXstudio, etc. |

---

## 🚀 Step-by-Step Migration & Reinstall Workflow

### Phase 1: On Your Current Arch Laptop (Before Wiping)
Run the automated backup script to save your VM, configurations, and scripts:
```bash
git clone https://github.com/<your-username>/arch-laptop.git ~/arch-laptop-repo
cd ~/arch-laptop-repo
chmod +x scripts/backup_old_arch.sh
sudo ./scripts/backup_old_arch.sh
```
*Copy `~/arch_backup_ready.tar.gz` and your VM disk `/var/lib/libvirt/images/ubuntu-vm.qcow2` to an external USB drive.*

---

### Phase 2: Fresh Base Installation
Boot your Arch Linux USB installer and follow [02-arch-installation-guide.md](file:///c:/Users/HP/Documents/GitHub/arch-laptop/docs/02-arch-installation-guide.md).
Key principle: Allocate **100% of remaining drive space to a single root partition (`/`)** so you never encounter artificial disk constraints again.

---

### Phase 3: Post-Installation Automation (On First Boot)
Clone this repository onto the new installation and run the staged setup scripts:

```bash
git clone https://github.com/<your-username>/arch-laptop.git ~/arch-laptop
cd ~/arch-laptop

# 1. Base Development, Audio, Microcode, YAY (AUR):
chmod +x scripts/*.sh
./scripts/01_post_install.sh

# 2. Ubuntu Look, Centered Dock, and Startup Music:
./scripts/02_setup_theming_and_sound.sh

# 3. Jupyter C++ Cling & VS Code Integration:
./scripts/03_setup_jupyter_cling.sh

# 4. 8086 Assembly Workspace (DOSBox, NASM, AFD):
./scripts/05_setup_dosbox_assembly.sh

# 5. QEMU / KVM Virtualization & Libvirt:
./scripts/06_setup_virtualization.sh

# 6. Tailscale Mesh & GNOME Remote Desktop:
./scripts/07_setup_tailscale_rdp.sh

# 7. Install All User Applications (OnlyOffice, VSCodium, Spotify, etc.):
./scripts/08_install_all_software.sh
```

---

## 🛠️ Repository Architecture

```
arch-laptop/
├── README.md                              <- Master knowledge base and entry point
├── docs/                                  <- 12 in-depth architectural guides
│   ├── 01-storage-and-partitioning.md
│   ├── 02-arch-installation-guide.md
│   ├── 03-backup-old-arch.md
│   ├── 04-ubuntu-look-and-theming.md
│   ├── 05-circular-alt-tab-switcher.md
│   ├── 06-bootup-login-music.md
│   ├── 07-jupyter-cpp-cling-vscode.md
│   ├── 08-claude-science-environment.md
│   ├── 09-dosbox-nasm-afd-setup.md
│   ├── 10-qemu-kvm-vm-migration.md
│   ├── 11-tailscale-and-remote-desktop.md
│   └── 12-software-catalog-pacman-aur.md
├── scripts/                               <- Production-ready automation scripts
│   ├── backup_old_arch.sh
│   ├── 01_post_install.sh
│   ├── 02_setup_theming_and_sound.sh
│   ├── 03_setup_jupyter_cling.sh
│   ├── 04_launch_jupyter_vscode.sh
│   ├── 05_setup_dosbox_assembly.sh
│   ├── 06_setup_virtualization.sh
│   ├── 07_setup_tailscale_rdp.sh
│   └── 08_install_all_software.sh
├── configs/                               <- Pre-built configs (DOSBox, Dconf, Desktop)
│   ├── dosbox.conf
│   ├── ubuntu_shortcuts.dconf
│   ├── dash_to_dock_settings.dconf
│   ├── ubuntu-login-sound.desktop
│   └── jupyter_cxx_kernel.json
└── packages/                              <- Manifest files
    ├── pacman-packages.txt
    └── aur-packages.txt
```
