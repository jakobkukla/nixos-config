{
  lib,
  config,
  ...
}: let
  cfg = config.profiles.laptop;
in {
  options.profiles.laptop = with lib; {
    enable = mkEnableOption "laptop profile";
  };

  config = lib.mkIf cfg.enable {
    modules = {
      hyprland = {
        enableNaturalScroll = true;

        # Automatically choose highest resolution for unknown monitors
        monitors = [", highres, auto, auto"];
      };

      sway.enableNaturalScroll = true;
    };

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

    # Touchpad configuration
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

    # Backlight brightness control
    programs.light.enable = true;

    home-manager.users.${config.modules.user.name} = {
      # Battery notification daemon
      services.batsignal.enable = true;
    };
  };
}
