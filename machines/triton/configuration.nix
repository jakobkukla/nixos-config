{latestZfsCompatibleKernel, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../base.nix
  ];

  profiles = {
    core.enable = true;
    desktop.enable = true;
    laptop.enable = true;
    work.enable = true;
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

  # FIXME: investigate if this can be turned on
  networking.firewall.enable = false;

  services.hardware.bolt.enable = true;
}
