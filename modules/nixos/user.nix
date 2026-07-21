{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.user;

  sshAuthorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWojtiUPbNshRKobtKSdt2Cp0HdHPn4qqpSzALSZ1rv jakob@aztec"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLDuYz2CQUZOtvP2qOKsdHqd5TdleLn95uHVxVTAod6 jakob@mirage"
  ];
in {
  options.modules.user = with lib; {
    enableXdgUser =
      mkEnableOption "XDG user directories and mime app list creation"
      // {
        default = true;
      };
  };

  config = lib.mkIf cfg.enable {
    users = {
      mutableUsers = false;
      defaultUserShell = pkgs.zsh;

      users = {
        root = {
          hashedPasswordFile = config.age.secrets.root.path;
          openssh.authorizedKeys.keys = sshAuthorizedKeys;
        };

        ${cfg.name} = {
          isNormalUser = true;
          hashedPasswordFile = config.age.secrets.${cfg.name}.path;
          home = "/home/${cfg.name}";
          extraGroups = ["wheel" "networkmanager" "video" "docker" "scanner" "lp"]; # Enable ‘sudo’ for the user.
          openssh.authorizedKeys.keys = sshAuthorizedKeys;
        };
      };
    };

    home-manager.users.${cfg.name} = {
      xdg = {
        enable = true;

        userDirs = {
          enable = cfg.enableXdgUser;
          createDirectories = cfg.enableXdgUser;
          # Don't set environment variables (default as of home.stateVersion >= 26.05)
          setSessionVariables = false;
        };

        mimeApps.enable = cfg.enableXdgUser;
      };
    };
  };
}
