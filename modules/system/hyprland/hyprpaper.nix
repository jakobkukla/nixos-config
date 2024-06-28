{
  lib,
  config,
  ...
}: let
  cfg = config.modules.hyprland;
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.modules.user.name} = {
      services.hyprpaper = {
        enable = true;
        settings = {
          # FIXME: this is stupid
          preload = builtins.map (x: builtins.elemAt (lib.strings.splitString "," x) 1) cfg.wallpapers;
          wallpaper = cfg.wallpapers;
        };
      };
    };
  };
}
