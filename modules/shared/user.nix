{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.user;
in {
  options.modules.user = with lib; {
    enable = mkEnableOption "user module";

    name = mkOption {
      type = types.str;
      default = "jakob";
    };

    homeDirectory = mkOption {
      type = types.str;
      default =
        if pkgs.stdenv.hostPlatform.isDarwin
        then "/Users/${cfg.name}"
        else "/home/${cfg.name}";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${cfg.name} = {
      # Home Manager needs a bit of information about you and the
      # paths it should manage.
      home.username = cfg.name;
      home.homeDirectory = cfg.homeDirectory;
    };
  };
}
