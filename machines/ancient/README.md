# ancient (Macbook Air - NixOS)

## Prerequisites

Run the [Asahi Linux installer](https://asahilinux.org/) from macOS twice:

1. Install Fedora Asahi Remix (Minimal) with ~25 GiB as a rescue and bootstrap
system.
2. Install the "UEFI environment only" option and name it `NixOS`.
Leave the remaining space unpartitioned.

After each install, hold the power button, select the new entry in the boot
picker and complete the setup (custom boot object, permissive security mode).

The rest of this guide runs from Fedora.

## Partition layout

### With Fedora (during installation)

| Partition | Type                 | Notes                          |
|-----------|----------------------|--------------------------------|
|  p1       | APFS                 | Apple iBoot system container   |
|  p2       | APFS                 | macOS                          |
|  p3       | APFS                 | Asahi stub (m1n1 stage 1)      |
|  p4       | boot (ESP)           | m1n1 stage 2, U-Boot, vendorfw |
|  p5       | LUKS (`enc`) → btrfs | subvolumes: root, home, nix    |
|  p6       | APFS                 | Fedora: Asahi stub             |
|  p7       | boot (ESP)           | Fedora: ESP                    |
|  p8       | ext4                 | Fedora: /boot                  |
|  p9       | btrfs                | Fedora: root, home             |
|  p10      | APFS                 | Apple recoveryOS               |

### Without Fedora (final)

| Partition | Type                 | Notes                          |
|-----------|----------------------|--------------------------------|
|  p1       | APFS                 | Apple iBoot system container   |
|  p2       | APFS                 | macOS                          |
|  p3       | APFS                 | Asahi stub (m1n1 stage 1)      |
|  p4       | boot (ESP)           | m1n1 stage 2, U-Boot, vendorfw |
|  p5       | LUKS (`enc`) → btrfs | subvolumes: root, home, nix    |
|  p6       | APFS                 | Apple recoveryOS               |

## Install Nix

Install Nix using the [Lix installer](https://lix.systems/install/#on-any-other-linuxmacos-system).

## Root shell

All following commands run as root. Open a root login shell (again after every
reboot).

```bash
sudo -i
```

## Create partition

Create a new partition in the largest free space and sort the partition table.

```bash
export DISK=/dev/nvme0n1

nix shell nixpkgs#gptfdisk -c sgdisk "$DISK" -n 0:0 -s
```

Reboot Fedora so the kernel picks up the new partition numbers.

## Create encrypted partition and btrfs subvolumes

```bash
export DISK=/dev/nvme0n1

cryptsetup --verify-passphrase -v luksFormat "$DISK"p5
cryptsetup open "$DISK"p5 enc

mkfs.btrfs /dev/mapper/enc

mount -t btrfs /dev/mapper/enc /mnt

btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix

umount /mnt
```

## Mount partitions and subvolumes and generate config

```bash
mount -o subvol=root,compress=zstd,noatime /dev/mapper/enc /mnt

mkdir -p /mnt/{boot,home,nix}
mount "$DISK"p4 /mnt/boot
mount -o subvol=home,compress=zstd,noatime /dev/mapper/enc /mnt/home
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/enc /mnt/nix

nix shell nixpkgs#nixos-install-tools -c \
  nixos-generate-config --root /mnt --show-hardware-config
```

Compare the output with machines/ancient/hardware-configuration.nix, adjust and
push to GitHub if needed.

## Generate ssh host keys

```bash
mkdir -p /mnt/etc/ssh

ssh-keygen \
  -t ed25519 \
  -f /mnt/etc/ssh/ssh_host_ed25519_key \
  -N "" -C "root@ancient"
```

## Rekey agenix secrets

Add new public host key (ed25519) to `secrets.nix` and rekey on an existing machine.

``` bash
# Add new ed25519 public host key.
cat /mnt/etc/ssh/ssh_host_ed25519_key.pub
hx secrets/secrets.nix

# Rekey existing secrets.
cd secrets
agenix -r

# Commit and push the changes.
git ...
```

## Install and reboot

NOTE: For now we need to bind mount the macOS firmware to the place NixOS
expects it.

```bash
mkdir -p /boot/vendorfw
mount --bind /mnt/boot/vendorfw /boot/vendorfw

nix shell nixpkgs#nixos-install-tools -c \
  nixos-install --no-root-password --flake github:jakobkukla/nixos-config#ancient

umount /boot/vendorfw
rmdir /boot/vendorfw

reboot
```

Hold the power button and select `NixOS` in the boot picker.

## Remove Fedora

See the [Asahi partitioning cheatsheet](https://asahilinux.org/docs/sw/partitioning-cheatsheet/).
Never touch the `Apple_APFS_Recovery` partition.

Make sure NixOS (not Fedora) is the default boot volume. Then delete Fedora's
partitions from macOS. `disk0sN` numbers don't match partition numbers, so
identify Fedora's stub container, ESP, `/boot` and root with `diskutil list` first.

```bash
diskutil list

diskutil apfs deleteContainer <fedora-stub>
diskutil eraseVolume free free <fedora-esp>
diskutil eraseVolume free free <fedora-boot>
diskutil eraseVolume free free <fedora-root>
```

Boot NixOS and fix the partition order again. Recovery moves from p10 to p6.
Reboot, then grow p5 into the freed space.

```bash
export DISK=/dev/nvme0n1

sudo sgdisk "$DISK" -s

reboot

sudo parted "$DISK" unit GiB print free   # find the end of the free space after p5
sudo parted "$DISK" resizepart 5 <end>
sudo cryptsetup resize enc
sudo btrfs filesystem resize max /
```

## References

- [Asahi Linux: Open OS Platform Interoperability](https://asahilinux.org/docs/platform/open-os-interop/)
- [Asahi Linux: Partitioning Cheatsheet](https://asahilinux.org/docs/sw/partitioning-cheatsheet/)
- [nixos-apple-silicon: UEFI Boot Standalone NixOS](https://github.com/nix-community/nixos-apple-silicon/blob/main/docs/uefi-standalone.md)
