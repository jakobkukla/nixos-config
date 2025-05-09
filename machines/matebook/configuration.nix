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
    work.enable = true;
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

  networking.firewall.enable = false; # Necessary for accessing ports from another machine (eg Jellyfin developement)

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable docker
  virtualisation.docker.enable = true;

  # Power management and performance scaling
  powerManagement.enable = true;
  services.auto-cpufreq.enable = true;
  services.thermald.enable = true;

  # Automatic SSD TRIM
  services.fstrim.enable = true;

  services.xserver = {
    enable = true;
    dpi = 192;
    xkb.layout = "de";
  };

  services.libinput = {
    enable = true;
    touchpad = {
      accelSpeed = "0.4";
      tapping = false;
      clickMethod = "clickfinger";
      disableWhileTyping = true;
      naturalScrolling = true;
    };
  };

  programs.light.enable = true;
}
