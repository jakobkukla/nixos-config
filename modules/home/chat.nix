{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.home.chat;
in {
  options.modules.home.chat = with lib; {
    enable = mkEnableOption "chat applications";
  };

  config = lib.mkIf cfg.enable {
    modules.home.senpai.enable = true;

    home.packages = with pkgs; [
      discord
      signal-desktop
      element-desktop
    ];
  };
}
