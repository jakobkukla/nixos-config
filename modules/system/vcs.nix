{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.vcs;
in {
  options.modules.vcs = with lib; {
    enable = mkEnableOption "Version Control Systems module";

    userName = mkOption {
      type = types.str;
      default = "jakobkukla";
      description = ''
        The user name configuration used for VCSs like git.
      '';
    };

    userEmail = mkOption {
      type = types.str;
      default = "jakob.kukla@gmail.com";
      description = ''
        The user email configuration used for VCSs like git.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      jujutsu
    ];

    home-manager.users.${config.modules.user.name} = {
      programs.git = {
        enable = true;
        lfs.enable = true;

        userName = cfg.userName;
        userEmail = cfg.userEmail;

        extraConfig = {
          init.defaultBranch = "main";
        };

        difftastic.enable = true;
      };

      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = cfg.userName;
            email = cfg.userEmail;
          };
        };
      };
    };
  };
}
