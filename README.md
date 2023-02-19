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
|  p3       | zfs   | -       |

#### Create encrypted swap, zfs pool, system container and datasets

```bash
export DISK=/dev/nvme0n1

mkfs.vfat -n boot "$DISK"p1

# Create swap with random encryption
cryptsetup open --type plain --key-file /dev/urandom "$DISK"p2 swap
mkswap /dev/mapper/swap
swapon /dev/mapper/swap

# Create ZFS root pool
zpool create \
  -o ashift=12 \
  -o autotrim=on \
  -R /mnt \
  -O acltype=posixacl \
  -O canmount=off \
  -O compression=zstd \
  -O dnodesize=auto \
  -O normalization=formD \
  -O relatime=on \
  -O xattr=sa \
  -O mountpoint=/ \
  rpool \
  "$DISK"p3

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
machines/matebook/hardware-configuration.nix, adjust and push to GitHub if needed.

#### Copy matebook ssh key to home directory

```bash
mkdir -p /mnt/home/jakob/.ssh
cp /path/to/.ssh/id_ed25519* /mnt/home/jakob/.ssh
```

#### Install and reboot

```bash
nixos-install --no-root-password --flake github:jakobkukla/nixos-config#matebook
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
