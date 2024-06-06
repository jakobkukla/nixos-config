{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}: {
  options.modules.home.spotify = with lib; {
    enable = mkEnableOption "spotify";
    enableGui =
      mkEnableOption "Spotify GUI client"
      // {
        default = true;
      };
  };

  config = lib.mkIf config.modules.home.spotify.enable {
    home.packages = lib.mkIf config.modules.home.spotify.enableGui [
      pkgs.spotify
    ];

    services.mpris-proxy.enable = true;

    services.spotifyd = {
      enable = true;

      package = pkgs.spotifyd.override {
        withPulseAudio = true;
        withMpris = true;
      };

      settings = {
        global = {
          username = "der_kukla";
          password_cmd = "cat ${osConfig.age.secrets.spotify.path}";
          backend = "pulseaudio";
          device_name = "${osConfig.networking.hostName}";
          bitrate = 320;
          use_mpris = true;
          cache_path = "${config.home.homeDirectory}/.cache/spotifyd";
          volume-normalisation = true;
          normalisation-pregain = -10;
          device_type = "computer";
        };
      };
    };
  };
}
