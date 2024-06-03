{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../base.nix

    # FIXME: temporary import place
    ../../modules/nixos
    ../../modules/profiles
  ];

  profiles.gui.enable = true;
  profiles.work.enable = true;

  # Enable crypt kernel modules early for cryptsetup to be faster (FIXME: Not sure if this is doing anything)
  boot.initrd.availableKernelModules = ["aesni_intel" "cryptd"];

  networking.hostName = "nixos-matebook";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Power management and performance scaling
  powerManagement.enable = true;
  services.auto-cpufreq.enable = true;
  services.thermald.enable = true;

  # Automatic SSD TRIM
  services.fstrim.enable = true;

  hardware.opengl = {
    enable = true;
  };

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
