{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../base.nix
    ../sway.nix
  ];

  networking.hostName = "nixos-pc";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.xserver = {
    enable = true;
    dpi = 192;
    layout = "de";
  };
}

