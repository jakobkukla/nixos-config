{
  config,
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
    laptop.enable = true;
    media.enable = true;
    gaming.enable = true;
    development.enable = true;
  };

  modules = {
    filesystem = {
      enable = true;
      fsType = "btrfs";
      enableImpermanence = true;
    };

    hyprland.wallpapers = [
      ",${config.modules.user.homeDirectory}/Pictures/wp.jpg"
    ];
  };

  # Enable crypt kernel modules early for cryptsetup to be faster (FIXME: Not sure if this is doing anything)
  boot.initrd.availableKernelModules = ["aesni_intel" "cryptd"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Linux kernel configuration
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos-matebook";

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  networking.firewall.enable = true;

  # Enable nftables
  networking.nftables.enable = true;

  # Enable podman
  virtualisation.podman.enable = true;

  # FIXME: not sure if this is needed?
  services.xserver = {
    enable = true;
    dpi = 192;
    xkb.layout = "de";
  };
}
