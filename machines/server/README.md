# server

## New installation

### Setup zpools

#### HDD pool

Create HDD pool `tank`.

```bash
sudo zpool create \
  -o ashift=12 \
  -O encryption=on \
  -O keyformat=passphrase \
  -O keylocation=prompt \
  -O compression=on \
  -O mountpoint=none \
  -O xattr=sa \
  -O acltype=posixacl \
  -O atime=off \
    tank \
    raidz2 \
      ata-ST8000VN004-2M2101_WKD2JH3R \
      ata-ST8000VN004-2M2101_WKD2VNPF \
      ata-ST8000VN004-2M2101_WSD4V85N \
      ata-ST8000VN004-2M2101_WSD57BK6 \
      ata-ST8000VN004-3CP101_WWZ2EA7Q \
      ata-ST8000VN004-3CP101_WWZ2EB0H

sudo zpool add tank cache ata-Samsung_SSD_840_EVO_250GB_S1DBNSBF459421R

sudo zfs create -o mountpoint=legacy -O recordsize=1M tank/data
```

#### SSD pool

##### Partition layout

| Partition | Type  | Size    |
|-----------|-------|---------|
|  p1       | boot  | 1 GiB   |
|  p2       | zfs   | -       |

##### Root pool and datasets

Create SSD root pool `rpool` and datasets.

```bash
sudo zpool create \
  -o ashift=12 \
  -O encryption=on \
  -O keyformat=passphrase \
  -O keylocation=prompt \
  -O compression=on \
  -O mountpoint=none \
  -O xattr=sa \
  -O acltype=posixacl \
  -O atime=off \
    rpool \
      nvme-Samsung_SSD_980_1TB_S649NL0TC31564P-part2

# NixOS
sudo zfs create -o mountpoint=legacy rpool/nixos

sudo zfs create -o mountpoint=legacy rpool/nixos/root
sudo zfs snapshot rpool/nixos/root@blank

sudo zfs create -o mountpoint=legacy rpool/nixos/home
sudo zfs create -o mountpoint=legacy rpool/nixos/nix
sudo zfs create -o mountpoint=legacy rpool/nixos/persist

# AppData
sudo zfs create -o mountpoint=legacy rpool/appdata
```

Format the EFI partition and mount partitions and datasets.

```bash
export DISK=/dev/nvme0n1

mkfs.fat -F 32 -n boot "$DISK"p1

mkdir -p /mnt/root
mount -t zfs rpool/nixos/root /mnt/root

mkdir -p /mnt/root/{boot,home,nix,persist}
mount -o umask=077 /dev/disk/by-label/boot /mnt/root/boot
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
sudo nixos-install --no-root-password --root /mnt/root --flake github:jakobkukla/nixos-config#server
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
sudo nixos-install --no-root-password --root /mnt/root --flake github:jakobkukla/nixos-config#server
reboot
```

### SSH keys for initrd

```bash
mkdir -p /persist/etc/secrets/initrd
ssh-keygen -t ed25519 -N "" -f /persist/etc/secrets/initrd/ssh_host_ed25519_key
```

## Unlock encrypted zpools remotely

```bash
ssh -p 2222 root@<ip-address> -t "zpool import -a; zfs load-key -a && killall zfs"
```
