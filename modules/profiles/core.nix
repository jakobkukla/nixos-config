{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.profiles.core;
in {
  options.profiles.core = with lib; {
    enable = mkEnableOption "core profile";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.jakob = {
      modules.home = {
        shell.enable = true;
        neovim.enable = true;
        helix.enable = true;
      };
    };
  };
}
