{latestZfsCompatibleKernel, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../base.nix
  ];

  profiles = {
    core.enable = true;
    chat.enable = false;
    desktop.enable = true;
    laptop.enable = true;
    media.enable = false;
    work.enable = false;
  };

  modules = {
    filesystem = {
      enable = true;
      fsType = "zfs";
      enableImpermanence = true;
    };

    hyprland.monitors = [
      "eDP-1,1920x1080,0x0,1.25"
    ];
  };

  boot.loader.systemd-boot = {
    enable = true;
    # Add Ubuntu's grub boot loader.
    extraEntries."ubuntu.conf" = ''
      title Ubuntu
      efi /efi/ubuntu/shimx64.efi     
    '';
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Linux kernel configuration
  boot.kernelPackages = latestZfsCompatibleKernel;

  networking.hostName = "moxz-triton";
  networking.hostId = "73e775f3";

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # NOTE: Docker is overwriting these. See https://github.com/NixOS/nixpkgs/issues/111852
  networking.firewall = {
    # FIXME: investigate if this can be turned on
    enable = false;
  };

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
