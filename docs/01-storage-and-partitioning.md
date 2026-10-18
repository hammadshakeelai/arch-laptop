# Storage Architecture & Partitioning Blueprint

## 1. Root Cause Analysis: Why the Previous Arch Install Ran Out of Space

In the previous installation, `/` (root) and `/home` were split into separate physical or logical partitions. While this was historical UNIX convention decades ago, on modern developer laptops it causes a severe disk bottleneck:

```
[ Traditional Split Partition Bottleneck ]
┌──────────────────────────────┬──────────────────────────────┐
│  / (Root Partition) [30-50GB]│  /home Partition [Remaining] │
│  ⚠️ FILLS UP RAPIDLY:        │  Plenty of unused space, but │
│  - Pacman cache (/var/cache) │  inaccessible to the OS!     │
│  - QEMU VMs (/var/lib/libvirt│                              │
│  - Flatpaks & Snaps          │                              │
│  - Docker / Podman images    │                              │
│  - LLVM, Clang, CUDA, TeXLive│                              │
└──────────────────────────────┴──────────────────────────────┘
```

When `/` is isolated:
- Pacman package downloads cache in `/var/cache/pacman/pkg/`
- QEMU/KVM virtual machine disk images default to `/var/lib/libvirt/images/`
- Docker and container layers live in `/var/lib/docker/`
- Heavy development tools like Clang, LLVM, CUDA, and TeXLive live in `/usr/`
- System logs accumulate in `/var/log/journal/`

Even if `/home` has 500GB free, root will fail with `No space left on device` (Error 28).

---

## 2. The Solution: Unified Single-Drive Layout

By eliminating artificial partition walls, **100% of the drive space** is shared dynamically between system files and user files:

```
[ Unified Drive Layout - Zero Space Waste ]
┌───────────────┬────────────────────────────────────────────────────────┐
│  EFI /boot    │  / (Root Filesystem - 100% Remaining Disk Space)       │
│  1.0 GB FAT32 │  - /home is simply a directory inside root             │
│               │  - /var, /usr, /home dynamically draw from ONE pool   │
└───────────────┴────────────────────────────────────────────────────────┘
```

---

## 3. Partition Layout Specification (UEFI / GPT)

For a standard NVMe or SSD (assuming disk is `/dev/nvme0n1` or `/dev/sda`):

| Partition | Size | Type Code | Filesystem | Mount Point | Purpose |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Partition 1** | `1024 MiB` (1GB) | `ef00` (EFI System) | `FAT32` (`vfat`) | `/boot` | UEFI Bootloader & Kernels |
| **Partition 2** | Remainder (100%) | `8300` (Linux Filesystem) | `Btrfs` OR `Ext4` | `/` | System root + /home combined |

> [!TIP]
> **Swap Memory**: Do not create a fixed swap partition! Use `zram-generator` (RAM compression). Arch dynamically manages swap inside RAM with zero disk wear and near-instant latency. If hibernation to disk is required, a dynamic swapfile can be created inside the root filesystem.

---

## 4. Filesystem Choice: Ext4 vs Btrfs

### Option A: Ext4 (Maximum Simplicity & Reliability)
- **Pros**: Rock solid, virtually indestructible, zero maintenance, standard Linux standard.
- **Mounting**: `/` mounts directly to Partition 2. `/home` is simply `/home` inside it.

### Option B: Btrfs with Subvolumes (Recommended for Modern Arch)
- **Pros**: Copy-on-write snapshots (never fear a broken update again), transparent zstd compression (saves 20-30% disk space automatically).
- **Subvolume setup**:
  - `@` mounted at `/`
  - `@home` mounted at `/home`
  - `@var_cache` mounted at `/var/cache`
  - `@snapshots` mounted at `/.snapshots`
- **Why this solves the problem**: Btrfs subvolumes **share the exact same unallocated disk pool**. They are not partitions. If you have 800GB on the disk, both `/` and `/home` have access to all 800GB.

---

## 5. Exact Disk Formatting Commands (Step-by-Step)

Assuming target drive is `/dev/nvme0n1` (replace with `/dev/sda` if SATA):

### Step 5.1: Create GPT Partitions with `fdisk` or `cfdisk`
```bash
# Launch interactive partitioner:
cfdisk /dev/nvme0n1

# 1. Select 'gpt' label type if new.
# 2. Partition 1: Size = 1G, Type = 'EFI System'
# 3. Partition 2: Size = [Remaining Space], Type = 'Linux filesystem'
# 4. Write changes and quit.
```

### Step 5.2 (Option A - Ext4):
```bash
# Format EFI:
mkfs.fat -F 32 -n EFI /dev/nvme0n1p1

# Format Root Ext4:
mkfs.ext4 -L ARCH_ROOT /dev/nvme0n1p2

# Mount:
mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

### Step 5.2 (Option B - Btrfs with Subvolumes):
```bash
# Format EFI:
mkfs.fat -F 32 -n EFI /dev/nvme0n1p1

# Format Root Btrfs:
mkfs.btrfs -L ARCH_ROOT /dev/nvme0n1p2

# Create subvolumes:
mount /dev/nvme0n1p2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var_log
btrfs subvolume create /mnt/@var_pkg
btrfs subvolume create /mnt/@snapshots
umount /mnt

# Mount subvolumes with zstd compression:
mount -o noatime,compress=zstd,subvol=@ /dev/nvme0n1p2 /mnt
mkdir -p /mnt/{boot,home,var/log,var/cache/pacman/pkg,.snapshots}
mount -o noatime,compress=zstd,subvol=@home /dev/nvme0n1p2 /mnt/home
mount -o noatime,compress=zstd,subvol=@var_log /dev/nvme0n1p2 /mnt/var/log
mount -o noatime,compress=zstd,subvol=@var_pkg /dev/nvme0n1p2 /mnt/var/cache/pacman/pkg
mount -o noatime,compress=zstd,subvol=@snapshots /dev/nvme0n1p2 /mnt/.snapshots

# Mount EFI:
mount /dev/nvme0n1p1 /mnt/boot
```
