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
    home-manager.users.${config.modules.user.name} = {
      modules.home.senpai.enable = true;

      home.packages = with pkgs; [
        discord
        signal-desktop-bin
        element-desktop
      ];
    };
  };
}
