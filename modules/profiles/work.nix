{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.profiles.work;
in {
  options.profiles.work = with lib; {
    enable = mkEnableOption "work profile";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
    };

    home-manager.users.${config.modules.user.name} = {
      home.packages = with pkgs; [
        mattermost-desktop
      ];

      programs.git = {
        userName = lib.mkForce "Jakob Kukla";
        userEmail = lib.mkForce "jakob@moxzcomm.com";
      };

      programs.keepassxc = {
        enable = true;
        settings = {
          Browser.Enabled = true;

          GUI = {
            ApplicationTheme = "dark";
            CompactMode = true;
            HidePasswords = true;
          };
        };
      };

      programs.distrobox = {
        enable = true;
        containers.ubuntu = {
          image = "ubuntu:22.04";
        };
      };
    };
  };
}
