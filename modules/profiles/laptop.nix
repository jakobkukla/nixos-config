{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.profiles.laptop;
in {
  options.profiles.laptop = with lib; {
    enable = mkEnableOption "laptop profile";
  };

  config = lib.mkIf cfg.enable {
    modules.windowManager = {
      hyprland = {
        enableNaturalScroll = true;

        # Automatically choose highest resolution for unknown monitors ("" is wildcard)
        monitors."" = {
          resolution = "highres";
          position = "auto";
          scale = "auto";
        };
      };

      sway.enableNaturalScroll = true;
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # Power management and performance scaling
    powerManagement.enable = true;
    services.thermald.enable = true;
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;

    environment.systemPackages = with pkgs; [
      # Backlight brightness control
      brightnessctl
    ];

    home-manager.users.${config.modules.user.name} = {
      # Battery notification daemon
      # services.batsignal.enable = true;
    };
  };
}
