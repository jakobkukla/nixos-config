{
  lib,
  config,
  ...
}: let
  cfg = config.profiles.core;
in {
  options.profiles.core = with lib; {
    enable = mkEnableOption "core profile";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.modules.user.name} = {
      modules.home = {
        shell.enable = true;
        neovim.enable = true;
        helix.enable = true;
      };
    };
  };
}
