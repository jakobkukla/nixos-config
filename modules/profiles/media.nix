{
  lib,
  config,
  ...
}: let
  cfg = config.profiles.media;
in {
  options.profiles.media = with lib; {
    enable = mkEnableOption "media profile";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.modules.user.name} = {
      modules.home.spotify.enable = true;

      programs.mpv.enable = true;

      # TODO: add easyeffects here! maybe as service?
    };
  };
}
