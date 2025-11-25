{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.profiles.desktop;
in {
  options.profiles.desktop = with lib; {
    enable = mkEnableOption "desktop profile";
  };

  config = lib.mkIf cfg.enable {
    # modules.hyprland.enable = true;
    # modules.niri.enable = true;
    # API could be better, how about window-managers.niri.enable?
    modules.windowManager = {
      enable = true;
      variant = "niri";
    };

    fonts.packages = with pkgs; [
      source-code-pro
      nerd-fonts.symbols-only
    ];

    # Add eduroam configuration
    modules.eduroam.enable = true;

    # FIXME: Does this make sense here?
    modules.printer.enable = true;

    # Enable sound.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

    home-manager.users.${config.modules.user.name} = {
      home.packages = with pkgs; [
        pavucontrol
        scrcpy # TODO: remove this?
        xpra
      ];

      modules.home = {
        defaultApplications.enable = true;

        dms.enable = true;

        browsers = {
          defaultBrowser = "zen-browser";

          firefox-based = {
            firefox.enable = true;
            zen-browser.enable = true;
          };
        };

        alacritty.enable = true;
        bitwarden.enable = true;
      };

      services.dunst.enable = true;

      programs.sioyek.enable = true;
    };
  };
}
