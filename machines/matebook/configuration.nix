{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../base.nix
    ../sway.nix
  ];

  networking.hostName = "nixos-matebook";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
 
  # Power management
  services.tlp.enable = true;

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
    ];
  };

  services.xserver = {
    enable = true;
    dpi = 192;
    layout = "de";

    libinput = {
      enable = true;
      touchpad = {
        accelSpeed = "0.4";
        tapping = false;
        clickMethod = "clickfinger";
        disableWhileTyping = true;
        naturalScrolling = true;
      };
    };
  };

  programs.light.enable = true;
}

