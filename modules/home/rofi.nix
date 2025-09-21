{
  lib,
  config,
  ...
}: let
  cfg = config.modules.home.rofi;
in {
  options.modules.home.rofi = with lib; {
    enable = mkEnableOption "Rofi window switcher";
  };

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
    };
  };
}
