{...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  device = {
    role = "workstation";

    hardware = {
      battery = true;
      bluetooth = true;
      touchpad = true;
      internalDisplay = true;
      wifi = true;
    };
  };

  modules.filesystem = {
    enable = true;
    fsType = "btrfs";
  };

  # Enable basic nixos-apple-silicon support.
  hardware.asahi.enable = true;
  hardware.asahi.peripheralFirmwareDirectory = (fetchTree {
    type = "path";
    path = "/boot/vendorfw/";
    narHash = "sha256-pvfzdyFO2fuL98+McrMoewokGIbySItKnkUgpOdzHJk=";
  }).outPath;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # Swap
  zramSwap.enable = true;

  networking.hostName = "ancient";

  networking.firewall.enable = true;

  # Enable nftables
  networking.nftables.enable = true;

  # Enable podman
  virtualisation.podman.enable = true;
}
