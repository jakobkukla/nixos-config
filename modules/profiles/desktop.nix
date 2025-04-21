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
    modules.hyprland.enable = true;

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
        firefox.enable = true;
        zen-browser = {
          enable = true;
          setDefaultBrowser = true;
        };
        alacritty.enable = true;
        bitwarden.enable = true;
      };

      services.dunst.enable = true;
    };
  };
}
