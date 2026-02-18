# nixos-config

![build](https://github.com/jakobkukla/nixos-config/actions/workflows/build.yml/badge.svg)
![update](https://github.com/jakobkukla/nixos-config/actions/workflows/update.yml/badge.svg)

## Setup

Setup instructions for specific machines can be found in `machines/<machine>`.

| Machine | Description    | Setup Instructions         |
|---------|----------------|----------------------------|
| aztec   | Matebook X Pro | [README](machines/aztec)   |
| cache   | Homelab        | [README](machines/cache)   |
| inferno | Sound System   | [README](machines/inferno) |
| mirage  | Gaming PC      | [README](machines/mirage)  |
| triton  | Work Machine   | [README](machines/triton)  |

## Test in VM

Build and run the VM with:

```bash
nixos-rebuild build-vm --flake .#$MACHINE
sudo ./result/bin/run-nixos-$MACHINE-vm
```

Run the resulting path with `sudo`, otherwise agenix will fail to decrypt secrets.
