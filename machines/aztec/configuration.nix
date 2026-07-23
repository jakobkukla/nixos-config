{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  profiles = {
    desktop.enable = true;
    laptop.enable = true;
    gaming.enable = true;
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

    hyprland.monitors."eDP-1" = {
      resolution = "3000x2000@60";
      position = "0x0";
      scale = "2";
    };
  };

  home-manager.users.${config.modules.user.name} = {
    modules.home = {
      chat.enable = true;
      development.enable = true;
      media.enable = true;
    };
  };

  # Enable crypt kernel modules early for cryptsetup to be faster (FIXME: Not sure if this is doing anything)
  boot.initrd.availableKernelModules = ["aesni_intel" "cryptd"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Linux kernel configuration
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "aztec";

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
