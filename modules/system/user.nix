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

        mimeApps.enable = true;
      };

      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      home.stateVersion = "21.11";

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
  };
}
