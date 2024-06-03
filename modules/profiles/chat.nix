{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.profiles.chat;
in {
  options.profiles.chat = with lib; {
    enable = mkEnableOption "chat profile";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.jakob = {
      home.packages = with pkgs; [
        discord
        signal-desktop
        element-desktop
        gomuks
      ];
    };
  };
}
