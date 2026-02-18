# aztec (Matebook X Pro)

## Partition layout

| Partition | Type  | Size    |
|-----------|-------|---------|
|  p1       | boot  | 512 MiB |
|  p2       | SWAP  | 16 GiB  |
|  p3       | btrfs | -       |

## Create encrypted partition and btrfs subvolumes

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

## Mount tmpfs, partitions and subvolumes and generate config

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

Compare the generated hardware-configuration.nix with machines/aztec/hardware-configuration.nix,
adjust and push to GitHub if needed.

## Copy aztec ssh key to home directory

```bash
mkdir -p /mnt/home/jakob/.ssh
cp /path/to/.ssh/id_ed25519* /mnt/home/jakob/.ssh
```

## Install and reboot

```bash
nixos-install --flake github:jakobkukla/nixos-config#aztec
reboot
```

## Switch to root user and update nix channels to fix the command-not-found script

---
**TODO:** Replace command-not-found.pl with nix-index and find
a way to circumvent building the index manually.

---

```bash
nix-channel --update
```
