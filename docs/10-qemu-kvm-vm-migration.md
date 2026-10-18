# QEMU / KVM Virtualization & Ubuntu VM Restoration

Restoring your previous `ubuntu-vm` from backup onto fresh Arch Linux is quick and seamless because QEMU/KVM virtual machine disks (`.qcow2`) and topology configurations (`.xml`) are standard across all Linux distributions.

---

## 1. Required Packages on Arch Linux

```bash
sudo pacman -S --needed \
    qemu-full \
    libvirt \
    virt-manager \
    virt-viewer \
    dnsmasq \
    iptables-nft \
    dmidecode \
    bridge-utils
```

---

## 2. Enabling KVM and Permissions

### 2.1 Add User to Groups
```bash
sudo usermod -aG libvirt,kvm $USER
```
*(Log out and log back in for group membership to take effect)*

### 2.2 Enable and Start Libvirt Services
```bash
sudo systemctl enable --now libvirtd.service
```

### 2.3 Enable the Default Virtual Network (NAT)
```bash
sudo virsh net-autostart default
sudo virsh net-start default
```

Verify virtual network status:
```bash
sudo virsh net-list --all
# Output should show: default | active | yes | yes
```

---

## 3. Restoring the `ubuntu-vm`

### Step 1: Copy the Disk Image Back
Copy the backed-up `.qcow2` file back to the default storage pool:
```bash
sudo cp /path/to/backup/ubuntu-vm.qcow2 /var/lib/libvirt/images/
sudo chown root:kvm /var/lib/libvirt/images/ubuntu-vm.qcow2
sudo chmod 660 /var/lib/libvirt/images/ubuntu-vm.qcow2
```

### Step 2: Define the Machine from XML
```bash
virsh define /path/to/backup/ubuntu-vm.xml
```

### Step 3: Verify and Start
Open **Virtual Machine Manager** from your application launcher or terminal:
```bash
virt-manager
```
Or start via command line:
```bash
virsh start ubuntu-vm
```
Your Ubuntu virtual machine will boot with the exact same CPU cores, RAM allocation, virtual network interfaces, and disk state as before!
