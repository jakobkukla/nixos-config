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
    user = mkOption {
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      mutableUsers = false;
      defaultUserShell = pkgs.zsh;

      users = {
        root.hashedPasswordFile = config.age.secrets.root.path;

        ${cfg.user} = {
          isNormalUser = true;
          hashedPasswordFile = config.age.secrets.${cfg.user}.path;
          home = "/home/${cfg.user}";
          extraGroups = ["wheel" "networkmanager" "video" "docker" "scanner" "lp"]; # Enable ‘sudo’ for the user.
        };
      };
    };

    home-manager.users.${cfg.user} = {
      # Home Manager needs a bit of information about you and the
      # paths it should manage.
      home.username = cfg.user;
      home.homeDirectory = "/home/${cfg.user}";

      xdg = {
        enable = true;

        userDirs = {
          enable = true;
          createDirectories = true;
        };
      };
    };
  };
}
