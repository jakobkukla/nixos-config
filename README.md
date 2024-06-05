# nixos-config

![cachix](https://github.com/jakobkukla/nixos-config/actions/workflows/cachix.yml/badge.svg)
![update](https://github.com/jakobkukla/nixos-config/actions/workflows/update.yml/badge.svg)

## Setup

### matebook

#### Partition layout

| Partition | Type  | Size    |
|-----------|-------|---------|
|  p1       | boot  | 512 MiB |
|  p2       | SWAP  | 16 GiB  |
|  p3       | btrfs | -       |

#### Create encrypted partition and btrfs subvolumes

```bash
export DISK=/dev/nvme0n1

cryptsetup --verify-passphrase -v luksFormat "$DISK"p3
cryptsetup open "$DISK"p3 enc

mkfs.vfat -n boot "$DISK"p1
mkswap "$DISK"p2
swapon "$DISK"p2
mkfs.btrfs /dev/mapper/enc

mount -t btrfs /dev/mapper/enc /mnt

btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist

umount /mnt
```

#### Mount tmpfs, partitions and subvolumes and generate config

---
**FIXME:** Mounting a ramdisk as root may be a bad idea for installation since
building the config needs a lot of disk space. Consider mounting some temporary
folder and deleting it afterwards or giving the tmpfs more ram.

---

```bash
mount -t tmpfs none /mnt

mkdir -p /mnt/{boot,home,nix,persist}
mount "$DISK"p1 /mnt/boot
mount -o subvol=home,compress=zstd,noatime /dev/mapper/enc /mnt/home
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/enc /mnt/nix
mount -o subvol=persist,compress=zstd,noatime /dev/mapper/enc /mnt/persist

nixos-generate-config --root /mnt
```

Compare the generated hardware-configuration.nix with machines/matebook/hardware-configuration.nix,
adjust and push to GitHub if needed.

#### Copy matebook ssh key to home directory

```bash
mkdir -p /mnt/home/jakob/.ssh
cp /path/to/.ssh/id_ed25519* /mnt/home/jakob/.ssh
```

#### Install and reboot

```bash
nixos-install --flake github:jakobkukla/nixos-config#matebook
reboot
```

#### Switch to root user and update nix channels to fix the command-not-found script

---
**TODO:** Replace command-not-found.pl with nix-index and find
a way to circumvent building the index manually.

---

```bash
nix-channel --update
```

### pc

#### Partition layout

| Partition | Type  | Size    |
|-----------|-------|---------|
|  p1       | boot  | 512 MiB |
|  p2       | zfs   | -       |

#### Create encrypted zfs pool, system container and datasets

Note the ashift value during zpool creation. From the Arch wiki:

Use -o ashift=9 for disks with a 512 byte physical sector size or -o ashift=12
for disks with a 4096 byte physical sector size. See `lsblk -S -o NAME,PHY-SEC`
to get the physical sector size of each SCSI/SATA disk. Remove -S if you want
the same value from all devices.
For NVMe drives, use `nvme id-ns /dev/nvmeXnY -H | grep "LBA Format"`
to get which LBA format is in use.

```bash
export DISK=/dev/nvme0n1

mkfs.vfat -n boot "$DISK"p1

# Create ZFS root pool
zpool create \
  -o ashift=9 \
  -o autotrim=on \
  -R /mnt \
  -O acltype=posixacl \
  -O canmount=off \
  -O compression=on \
  -O dnodesize=auto \
  -O relatime=on \
  -O xattr=sa \
  -O mountpoint=none \
  rpool \
  "$DISK"p2

# Create encrypted ZFS root system container
zfs create \
  -o canmount=off \
  -o mountpoint=none \
  -o encryption=on \
  -o keylocation=prompt \
  -o keyformat=passphrase \
  rpool/nixos

zfs create -o mountpoint=legacy rpool/nixos/root
zfs snapshot rpool/nixos/root@blank

zfs create -o mountpoint=legacy rpool/nixos/home
zfs create -o mountpoint=legacy rpool/nixos/nix
zfs create -o mountpoint=legacy rpool/nixos/persist
```

#### Mount tmpfs, partitions and datasets and generate config

```bash
mount -t zfs rpool/nixos/root /mnt

mkdir -p /mnt/{boot,home,nix,persist}
mount "$DISK"p1 /mnt/boot
mount -t zfs rpool/nixos/home /mnt/home
mount -t zfs rpool/nixos/nix /mnt/nix
mount -t zfs rpool/nixos/persist /mnt/persist

nixos-generate-config --root /mnt
```

Compare the generated hardware-configuration.nix with
machines/pc/hardware-configuration.nix, adjust and push to GitHub if needed.

#### Copy pc ssh key to home directory

```bash
mkdir -p /mnt/home/jakob/.ssh
cp /path/to/.ssh/id_ed25519* /mnt/home/jakob/.ssh
```

#### Install and reboot

```bash
nixos-install --no-root-password --flake github:jakobkukla/nixos-config#pc
reboot
```

#### Switch to root user and update nix channels to fix the command-not-found script

---
**TODO:** Replace command-not-found.pl with nix-index
and find a way to circumvent building the index manually.

---

```bash
nix-channel --update
```

## Test in VM

Build and run the VM with:

```bash
nixos-rebuild build-vm --flake .#$MACHINE
sudo ./result/bin/run-nixos-$MACHINE-vm
```

Run the resulting path with `sudo`, otherwise agenix will fail to decrypt secrets.
