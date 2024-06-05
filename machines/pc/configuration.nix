{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../base.nix
  ];

  profiles = {
    core.enable = true;
    chat.enable = true;
    desktop.enable = true;
    laptop.enable = false;
    media.enable = true;
    gaming.enable = true;
    work.enable = false;
  };

  modules = {
    filesystem = {
      enable = true;
      fsType = "zfs";
      enableImpermanence = true;
    };

    hyprland.monitors = [
      "DP-1,2560x1440@144,0x0,1"
      "DP-2,3840x2160@60,2560x0,1.5"
    ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # Linux kernel configuration
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  networking.hostName = "nixos-pc";
  networking.hostId = "4090d928";

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  networking.firewall.enable = false; # Necessary for accessing ports from another machine (eg Jellyfin developement)
}
