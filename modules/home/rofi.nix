{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.home.rofi;
in {
  options.modules.home.rofi = with lib; {
    enable = mkEnableOption "Rofi window switcher";
    enableWayland =
      mkEnableOption "rofi-wayland package"
      // {
        default = true;
      };
  };

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = lib.mkIf cfg.enableWayland pkgs.rofi-wayland;
    };
  };
}
