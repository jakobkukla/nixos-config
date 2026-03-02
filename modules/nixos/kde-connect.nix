{
  lib,
  config,
  ...
}: let
  cfg = config.modules.kde-connect;
in {
  options.modules.kde-connect = with lib; {
    enable = mkEnableOption "KDE Connect";
  };

  config = lib.mkIf cfg.enable {
    programs.kdeconnect = {
      # Opens the necessary ports.
      enable = true;
      # Package is managed by home manager.
      package = null;
    };

    home-manager.users.${config.modules.user.name} = {
      services.kdeconnect.enable = true;
    };
  };
}
