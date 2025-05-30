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
    modules = {
      nix.enable = true;
      user.enable = true;
      shell.enable = true;
      neovim.enable = true;
    };

    home-manager.users.${config.modules.user.name} = {
      modules.home = {
        helix.enable = true;
      };
    };
  };
}
