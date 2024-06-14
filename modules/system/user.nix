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
    enableXdgUser =
      mkEnableOption "XDG user directories and mime app list creation"
      // {
        default = true;
      };
    name = mkOption {
      type = types.str;
      default = "jakob";
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      mutableUsers = false;
      defaultUserShell = pkgs.zsh;

      users = {
        root.hashedPasswordFile = config.age.secrets.root.path;

        ${cfg.name} = {
          isNormalUser = true;
          hashedPasswordFile = config.age.secrets.${cfg.name}.path;
          home = "/home/${cfg.name}";
          extraGroups = ["wheel" "networkmanager" "video" "docker" "scanner" "lp"]; # Enable ‘sudo’ for the user.
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWojtiUPbNshRKobtKSdt2Cp0HdHPn4qqpSzALSZ1rv jakob.kukla@gmail.com"
          ];
        };
      };
    };

    home-manager.users.${cfg.name} = {
      # Home Manager needs a bit of information about you and the
      # paths it should manage.
      home.username = cfg.name;
      home.homeDirectory = "/home/${cfg.name}";

      xdg = {
        enable = true;

        userDirs = {
          enable = cfg.enableXdgUser;
          createDirectories = cfg.enableXdgUser;
        };

        mimeApps.enable = cfg.enableXdgUser;
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
