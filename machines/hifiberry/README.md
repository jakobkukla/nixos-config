# hifiberry

## New Installation

### SD Image

Download and decompress latest aarch64 SD image from [hydra](https://hydra.nixos.org/job/nixos/trunk-combined/nixos.sd_image.aarch64-linux/latest):

```bash
wget https://hydra.nixos.org/build/283233356/download/1/<name>.img.zst
unzstd -d <name>.img.zst
sudo dd if=<name>.img of=/dev/sdX bs=4096 conv=fsync status=progress
```

### SSH Host Keys

Set a password for nixos in tty.

Get public SSH host key, add to agenix and rekey.

```bash
ssh nixos@<ip-address> -- cat /etc/ssh/ssh_host_ed25519_key.pub

cd secrets
vim secrets.nix # Add host key

agenix -r
```

### Deploy configuration

```bash
nixos-rebuild switch \
  --flake github:jakobkukla/nixos-config#hifiberry \
  --target-host root@<ip-address>
```

### Update Firmware

```bash
ssh pi@<ip-address>

nix-shell -p raspberrypi-eeprom
mount /dev/disk/by-label/FIRMWARE /mnt
BOOTFS=/mnt FIRMWARE_RELEASE_STATUS=stable rpi-eeprom-update -d -a
```

## Deploy configuration update remotely

The local machine needs a working cross-compilation environment (if applicable).

```bash
nixos-rebuild switch \
  --flake github:jakobkukla/nixos-config#hifiberry \
  --target-host root@<ip-address>
```
