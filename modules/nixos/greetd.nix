{
  lib,
  config,
  ...
}: let
  cfg = config.modules.greetd;
in {
  options.modules.greetd = with lib; {
    enable = mkEnableOption "greetd login manager";
    command = mkOption {
      type = types.str;
    };
    user = mkOption {
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    # services.greetd = {
    #   enable = true;
    #   settings = rec {
    #     default_session = {
    #       command = cfg.command;
    #       user = cfg.user;
    #     };
    #     initial_session = default_session;
    #   };
    # };

    # unlock GPG keyring on login
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
