{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../base.nix
    ../../home/matebook.nix
  ];

  boot.kernelParams = [ "i915.enable_psr=0" ];

  networking.hostName = "nixos-matebook";

  hardware.bluetooth.enable = true;
 
  # Power management
  services.tlp.enable = true;

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

    desktopManager.xterm.enable = false;
    displayManager.defaultSession = "none+bspwm";
    displayManager.lightdm = {
      greeters.mini = {
        enable = true;
        user = "jakob";
        extraConfig = ''
          [greeter]
          user = jakob
          password-input-width = 15
          show-input-cursor = false
          [greeter-theme]
          font = "Source Code Pro"
          font-size = 30px
          background-image = ""
          background-color = "#0e0409"
          border-width = 5px
          border-color = "#edf0e1"
          text-color = "#0e0409"
          password-color = "#edf0e1"
          password-background-color = "#0e0409"
          password-border-radius = 0.341125em
          window-color = "#63956D"
          layout-space = 40
        '';
      };

      # This is needed for tiny and mini greeters
      extraSeatDefaults = "user-session = ${config.services.xserver.displayManager.defaultSession}";
    };
    windowManager.bspwm.enable = true;
  };

  programs.light.enable = true;
}

