# agency (MacBook Air)

## Install Nix

Install Nix using the [Lix installer](https://lix.systems/install/#on-any-other-linuxmacos-system).

## Install the configuration

```bash
sudo nix run nix-darwin/master#darwin-rebuild -- \
  --flake github:jakobkukla/nixos-config#agency switch
```
