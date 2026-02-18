# triton (Work Machine)

## New installation

### Setup zpool

#### SSD pool

Install nixos side-by-side to the existing LVM-on-LUKS ubuntu setup.
Use existing efi partition as /boot. Ignore ubuntu's /boot partition.

##### Partition layout

```
| Partition       | Type           | Size    |
|-----------------|----------------|---------|
|  p1             | /boot          | 1 GiB   |
|  p2             | (Ubuntu /boot) | 2 GiB   |
|  p3             | LUKS           | -       |
|  └─vg           | lvm            | -       |
|    ├─ubuntu-lv  | ext4           | 50%     |
|    └─nixos-lv   | zfs            | 50%     |
```

##### Root pool and datasets

Create SSD root pool `rpool` and datasets.

```bash
sudo zpool create \
  -o ashift=12 \
  -O compression=on \
  -O mountpoint=none \
  -O xattr=sa \
  -O acltype=posixacl \
  -O atime=off \
    rpool \
      dm-name-vg-nixos--lv

# NixOS
sudo zfs create -o mountpoint=legacy rpool/nixos

sudo zfs create -o mountpoint=legacy rpool/nixos/root
sudo zfs snapshot rpool/nixos/root@blank

sudo zfs create -o mountpoint=legacy rpool/nixos/home
sudo zfs create -o mountpoint=legacy rpool/nixos/nix
sudo zfs create -o mountpoint=legacy rpool/nixos/persist
```

Mount partitions and datasets.

```bash
export DISK=/dev/nvme0n1

mkdir -p /mnt/root
mount -t zfs rpool/nixos/root /mnt/root

mkdir -p /mnt/root/{boot,home,nix,persist}
mount -o umask=077 "$DISK"p1 /mnt/root/boot
mount -t zfs rpool/nixos/home /mnt/root/home
mount -t zfs rpool/nixos/nix /mnt/root/nix
mount -t zfs rpool/nixos/persist /mnt/root/persist
```

#### Generate hardware-configuration.nix

Generate the hardware configuration file and adapt as needed.
Commit and push the changes.

```bash
nixos-generate-config --root /mnt/root

git ...
```

### SSH keys and secrets

Create ssh host keys and save them on new machine.

```bash
sudo mkdir -p /mnt/root/persist/etc/ssh

sudo ssh-keygen \
  -t rsa -b 4096 \
  -f /mnt/root/persist/etc/ssh/ssh_host_rsa_key \
  -N "" -C "root@nixos-$MACHINE"

sudo ssh-keygen \
  -t ed25519 \
  -f /mnt/root/persist/etc/ssh/ssh_host_ed25519_key \
  -N "" -C "root@nixos-$MACHINE"
```

Install once to create `/etc/ssh` and copy to `/persist`.

```bash
sudo nixos-install --no-root-password --root /mnt/root --flake github:jakobkukla/nixos-config#$MACHINE
cp -r /mnt/root/etc/ssh /mnt/root/persist/etc
```

Add new pub host key to secrets.nix and rekey on an existing machine.
Then commit and push.

``` bash
cd secrets
agenix -r

git ...
```

### Install

```bash
sudo nixos-install --no-root-password --root /mnt/root --flake github:jakobkukla/nixos-config#$MACHINE
reboot
```
