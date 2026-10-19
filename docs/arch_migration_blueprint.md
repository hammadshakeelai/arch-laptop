# Arch Linux Laptop Reinstallation & Migration Blueprint (100% Ready)

The pre-reinstall salvage and backup operation is **100% COMPLETE AND VERIFIED**. All personal data, virtual machines, university coursework, custom C++ Jupyter environments, Claude Science tools, and Ubuntu aesthetics are safely stored on your Ventoy USB drive and synced to this repository.

---

## 📦 Verified Inventory on Ventoy USB (`ARCH_LAPTOP_SALVAGE/`)

| Asset | Size | Source | Notes |
| :--- | :--- | :--- | :--- |
| **`ubuntu-vm.qcow2`** | **33 GB** | Ubuntu `/var/lib/libvirt` | Full Virt-Manager QEMU/KVM virtual machine disk |
| **`ubuntu-vm.xml`** | **7.5 KB** | Ubuntu `/etc/libvirt` | Exact hardware topology (4 cores, 4GB RAM, virtio bus) |
| **`claude-science.tar.gz`** | **2.6 GB** | Arch `~/.claude-science` | Full environment with Conda envs, libraries & symlinks |
| **`University IMS/`** | **1.9 GB** | Arch `~/University IMS` | All 4 semesters of BS Software Engineering coursework & PDFs |
| **`ubuntu_coursework/`** | **16 MB** | Ubuntu `~/` | `Machine-Learning`, `Parallel-and-Distributed-Computing`, `Programming-For-AI` |
| **`dotfiles_and_configs.tar.gz`** | **106 MB** | Arch `~/` | `~/.config`, `~/.bashrc`, `~/.vscode-oss`, and `~/.gitconfig` |
| **`tailscaled.state`** | **2.8 KB** | Arch `/var/lib/tailscale` | Preserves machine identity and exact IP `100.98.133.25` |
| **`ubuntu_sounds/`** | Folder | Ubuntu `/usr/share/sounds` | `warty-startup.oga`, `desktop-login.oga`, sound themes |
| **`ubuntu_wallpapers/`** | Folder | Ubuntu `/usr/share/backgrounds`| Official 4K Resolute Raccoon & community wallpapers |
| **`ubuntu_actual_dconf.ini`** | **13 KB** | Ubuntu `dconf` | Dock settings (size 56, bottom) & custom shortcuts (`Alt+t`, `Super+x`) |
| **`asm_workspace/`** | **388 KB** | Arch `~/asm_workspace` | `AFD.EXE`, `nasm.exe`, `.asm` source & `.com` binaries |
| **`notebooks/`** | **92 KB** | Arch `~/notebooks` | All interactive C++ Jupyter notebooks |
| **`jupyter/`** | **128 KB** | Arch `jupyter/kernels` | `xcpp23` (C++23 clang-repl), `cling-cpp17`, etc. |
| **Shell Scripts** | Scripts | Arch `~/` | `jupytercpp.sh`, `jupytercppweb.sh`, `upvolume.sh`, `downvolume.sh` |
| **Package Manifests** | Text | Arch system | Explicit lists of all 167 native packages and AUR packages |

---

## 💻 Hardware Profile (For Reinstall)

- **CPU**: AMD Processor (use package `amd-ucode`)
- **GPU**: AMD Radeon Graphics (use `vulkan-radeon` and `xf86-video-amdgpu`)
- **Audio**: PipeWire with `sof-firmware`
- **Kernel**: `linux-zen` (low latency) + `linux` fallback
- **Disk**: 256 GB NVMe SSD (`/dev/nvme0n1`)

---

## 🛠️ Step-by-Step Reinstallation Plan (Single Drive Unified Storage)

### Step 1: Boot into Ventoy Arch ISO
1. Reboot your laptop and press `F12` / `F2` / `Esc` to select the USB drive.
2. Select the Arch Linux ISO from your Ventoy menu.

### Step 2: Disk Formatting (No more running out of root space!)
Wipe the drive and create **only 2 partitions**:
```bash
cfdisk /dev/nvme0n1
# Delete all old partitions (p1, p2, p3, p4)
# Partition 1: Size = 1G, Type = 'EFI System'
# Partition 2: Size = [Remaining 237+ GB], Type = 'Linux filesystem'
# Write and Quit
```

Format & Mount:
```bash
# Format EFI:
mkfs.fat -F 32 -n EFI /dev/nvme0n1p1

# Format Root (Ext4 or Btrfs):
mkfs.ext4 -L ARCH_ROOT /dev/nvme0n1p2

# Mount:
mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

### Step 3: Base Installation
```bash
pacstrap -K /mnt \
  base base-devel linux-zen linux-firmware amd-ucode linux-zen-headers \
  networkmanager sudo git neovim pipewire pipewire-pulse pipewire-alsa wireplumber \
  zram-generator sof-firmware vulkan-radeon xf86-video-amdgpu

genfstab -U /mnt >> /mnt/etc/fstab
```

### Step 4: System Configuration in Chroot
```bash
arch-chroot /mnt

# Timezone & Locale:
ln -sf /usr/share/zoneinfo/Asia/Karachi /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "archlinux" > /etc/hostname

# User & Sudo:
passwd
useradd -m -G wheel,audio,video,storage,optical -s /bin/bash hammad
passwd hammad
EDITOR=nvim visudo   # Uncomment: %wheel ALL=(ALL:ALL) ALL

# Services & ZRAM:
systemctl enable NetworkManager

cat <<EOF > /etc/systemd/zram-generator.conf
[zram0]
zram-size = min(ram / 2, 8192)
compression-algorithm = zstd
EOF

# Bootloader (systemd-boot):
bootctl install

cat <<EOF > /boot/loader/loader.conf
default  arch.conf
timeout  3
console-mode max
editor   no
EOF

ROOT_UUID=$(blkid -s PARTUUID -o value /dev/nvme0n1p2)
cat <<EOF > /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux-zen
initrd  /amd-ucode.img
initrd  /initramfs-linux-zen.img
options root=PARTUUID=${ROOT_UUID} rw
EOF

exit
umount -R /mnt
reboot
```

---

### Step 5: Post-Install Restoration (On First Boot)
Log into your new Arch system, plug in your Ventoy USB, and run the automated setup scripts from this repo:
```bash
git clone https://github.com/hammadshakeel61/arch-laptop.git ~/arch-laptop
cd ~/arch-laptop
chmod +x scripts/*.sh

# 1. Base tools, PipeWire audio & YAY:
./scripts/01_post_install.sh

# 2. Ubuntu Look, authentic Dock & Startup Music:
./scripts/02_setup_theming_and_sound.sh

# 3. Restore C++ Jupyter Cling environment:
./scripts/03_setup_jupyter_cling.sh

# 4. Restore 8086 Assembly Workspace (DOSBox + AFD):
./scripts/05_setup_dosbox_assembly.sh

# 5. Restore KVM/Virt-Manager and Ubuntu VM:
./scripts/06_setup_virtualization.sh

# 6. Restore Tailscale and Remote Desktop:
./scripts/07_setup_tailscale_rdp.sh

# 7. Install All Software (OnlyOffice, Spotify, VSCodium, etc.):
./scripts/08_install_all_software.sh

# 8. Restore your personal folders from USB:
cp -r /run/media/hammad/Ventoy/ARCH_LAPTOP_SALVAGE/University\ IMS ~/
cp -r /run/media/hammad/Ventoy/ARCH_LAPTOP_SALVAGE/notebooks ~/
tar -xzf /run/media/hammad/Ventoy/ARCH_LAPTOP_SALVAGE/claude-science.tar.gz -C ~/
```
