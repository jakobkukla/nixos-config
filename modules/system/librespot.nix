{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.librespot;

  librespotEnvironment = lib.mkMerge [
    {
      LIBRESPOT_NAME = cfg.settings.name;
      LIBRESPOT_DEVICE_TYPE = cfg.settings.deviceType;
      LIBRESPOT_BITRATE = toString cfg.settings.bitrate;
      LIBRESPOT_BACKEND = cfg.settings.backend;
      LIBRESPOT_DEVICE = lib.optionalString (cfg.settings.device != null) cfg.settings.device;
      LIBRESPOT_MIXER = cfg.settings.mixer;
    }
    (lib.mkIf cfg.settings.enableVolumeNormalisation {
      LIBRESPOT_ENABLE_VOLUME_NORMALISATION = "1";
      LIBRESPOT_NORMALISATION_PREGAIN = toString cfg.settings.normalisationPregain;
    })
  ];
in {
  options.modules.librespot = with lib; {
    enable = mkEnableOption "librespot Open Source Spotify client library";

    settings = mkOption {
      description = "librespot settings";
      type = types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            default = "Librespot";
          };

          deviceType = mkOption {
            type = types.enum ["computer" "tablet" "smartphone" "speaker" "tv" "avr" "stb" "audiodongle" "gameconsole" "castaudio" "castvideo" "automobile" "smartwatch" "chromebook" "carthing" "homething"];
            default = "speaker";
          };

          bitrate = mkOption {
            type = types.enum [96 160 320];
            default = 160;
          };

          backend = mkOption {
            type = types.enum ["rodio" "alsa" "pulseaudio" "pipe" "subprocess"];
            default = "rodio";
          };

          device = mkOption {
            type = types.nullOr types.str;
          };

          mixer = mkOption {
            type = types.enum ["softvol" "alsa"];
            default = "softvol";
          };

          enableVolumeNormalisation = mkEnableOption "Enables volume normalisation";

          normalisationPregain = mkOption {
            type = types.int;
            default = 0;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.librespot = {
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after = [
        "network-online.target"
        "sound.target"
      ];
      description = "librespot, an Open Source Spotify client library";
      environment = lib.mkMerge [
        {SHELL = "/bin/sh";}
        librespotEnvironment
      ];
      serviceConfig = {
        ExecStart = "${pkgs.librespot}/bin/librespot --cache /var/cache/librespot";
        Restart = "always";
        RestartSec = 12;
        DynamicUser = true;
        CacheDirectory = "librespot";
        SupplementaryGroups = ["audio"];
      };
    };
  };
}
