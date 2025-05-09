# nixos-config

![build](https://github.com/jakobkukla/nixos-config/actions/workflows/build.yml/badge.svg)
![update](https://github.com/jakobkukla/nixos-config/actions/workflows/update.yml/badge.svg)

## Setup

Setup instructions for specific machines can be found in `machines/<machine>`.

| Machine   | Setup Instructions           |
|-----------|------------------------------|
| matebook  | [README](machines/matebook)  |
| pc        | [README](machines/pc)        |
| server    | [README](machines/server)    |
| hifiberry | [README](machines/hifiberry) |
| triton    | [README](machines/triton)    |

## Test in VM

Build and run the VM with:

```bash
nixos-rebuild build-vm --flake .#$MACHINE
sudo ./result/bin/run-nixos-$MACHINE-vm
```

Run the resulting path with `sudo`, otherwise agenix will fail to decrypt secrets.
