{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.profiles.gui;
in {
  options.profiles.gui = with lib; {
    enable = mkEnableOption "gui profile";
  };

  config = lib.mkIf cfg.enable {
    modules.hyprland.enable = true;

    home-manager.users.jakob = {
      home.packages = with pkgs; [
        scrcpy # TODO: remove this?
        xpra
      ];

      modules.home = {
        firefox.enable = true;
        alacritty.enable = true;
      };

      services.dunst.enable = true;
    };
  };
}
