{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.home.media;
in {
  options.modules.home.media = with lib; {
    enable = mkEnableOption "media applications";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      jellyfin-media-player
    ];

    modules.home.spotify.enable = true;

    programs.mpv.enable = true;

    # TODO: add easyeffects here! maybe as service?
  };
}
