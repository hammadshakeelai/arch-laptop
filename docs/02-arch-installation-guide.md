# Complete Arch Linux Installation Walkthrough

This guide details the exact steps to install a fresh, unpartitioned, clean Arch Linux system on the laptop.

---

## Phase 1: Live Environment Preparation

### 1. Boot the Live USB
Insert your Arch Linux USB installer (created with Rufus or Ventoy) and boot via UEFI (typically `F12`, `F2`, or `Esc` on laptop startup).

### 2. Verify UEFI Mode
```bash
ls /sys/firmware/efi/efivars
```
If directory contents appear, UEFI mode is confirmed.

### 3. Connect to Wi-Fi (if not on Ethernet)
```bash
iwctl
# Inside the iwd prompt:
[iwd]# device list
[iwd]# station wlan0 scan
[iwd]# station wlan0 get-networks
[iwd]# station wlan0 connect "YOUR_WIFI_SSID"
# (Enter password)
[iwd]# exit

# Verify connection:
ping -c 3 archlinux.org
```

### 4. Update System Clock
```bash
timedatectl set-ntp true
```

---

## Phase 2: Disk Partitioning and Mounting

Follow [01-storage-and-partitioning.md](file:///c:/Users/HP/Documents/GitHub/arch-laptop/docs/01-storage-and-partitioning.md).

For quick reference (Ext4 single-partition layout on `/dev/nvme0n1`):
```bash
# Wipe & Partition:
cfdisk /dev/nvme0n1
# -> Partition 1: 1G, EFI System
# -> Partition 2: Remainder, Linux Filesystem

# Format:
mkfs.fat -F 32 -n EFI /dev/nvme0n1p1
mkfs.ext4 -L ARCH_ROOT /dev/nvme0n1p2

# Mount target:
mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

---

## Phase 3: Base System Installation

Install the kernel, firmware, base development tools, and drivers:
```bash
pacstrap -K /mnt \
  base \
  base-devel \
  linux \
  linux-firmware \
  linux-headers \
  networkmanager \
  sudo \
  git \
  neovim \
  zram-generator \
  pipewire \
  pipewire-pulse \
  pipewire-alsa \
  wireplumber
```

Generate the file system table (`fstab`):
```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

---

## Phase 4: Chroot & System Configuration

Enter the newly installed system:
```bash
arch-chroot /mnt
```

### 1. Timezone & Clock
```bash
ln -sf /usr/share/zoneinfo/Asia/Karachi /etc/localtime
hwclock --systohc
```
*(Adjust `Asia/Karachi` to your specific timezone if needed)*

### 2. Localization
Edit `/etc/locale.gen` and uncomment:
```
en_US.UTF-8 UTF-8
```
Generate locales:
```bash
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

### 3. Network Identity
```bash
echo "archlinux" > /etc/hostname

cat <<EOF > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   archlinux.localdomain archlinux
EOF
```

### 4. Root Password
```bash
passwd
```

### 5. Create Developer User (`hammad`)
```bash
useradd -m -G wheel,audio,video,storage,optical -s /bin/bash hammad
passwd hammad
```

Grant `sudo` access to `wheel` group:
```bash
EDITOR=nvim visudo
# Uncomment the line:
# %wheel ALL=(ALL:ALL) ALL
```

### 6. Enable Core Services
```bash
systemctl enable NetworkManager
```

### 7. Configure ZRAM Swap (Eliminates Out-Of-Memory Crashes)
```bash
cat <<EOF > /etc/systemd/zram-generator.conf
[zram0]
zram-size = min(ram / 2, 8192)
compression-algorithm = zstd
EOF
```

---

## Phase 5: Bootloader (systemd-boot or GRUB)

### Option A: `systemd-boot` (Fastest, Minimal, Built-in)
```bash
bootctl install

cat <<EOF > /boot/loader/loader.conf
default  arch.conf
timeout  3
console-mode max
editor   no
EOF

# Find PARTUUID of root partition (/dev/nvme0n1p2):
ROOT_UUID=$(blkid -s PARTUUID -o value /dev/nvme0n1p2)

cat <<EOF > /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=PARTUUID=${ROOT_UUID} rw
EOF
```

### Option B: `GRUB` (Traditional)
```bash
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

---

## Phase 6: Exit & Reboot

```bash
exit
umount -R /mnt
reboot
```

Remove the USB flash drive when prompted. Your Arch laptop will now boot directly into a unified-disk Arch Linux system!
