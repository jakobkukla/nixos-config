{
  lib,
  config,
  ...
}: let
  cfg = config.profiles.hifiberry;

  deviceName = "HiFiBerry";
  alsaDeviceName = "default:CARD=sndrpihifiberry";
in {
  options.profiles.hifiberry = with lib; {
    enable = mkEnableOption "HiFiBerry profile";
  };

  config = lib.mkIf cfg.enable {
    modules.librespot = {
      enable = true;
      settings = {
        name = deviceName;
        bitrate = 320;
        enableVolumeNormalisation = true;
      };
    };

    services.shairport-sync = {
      enable = true;
      arguments = "-a ${deviceName} --output=alsa -- -d ${alsaDeviceName}";
    };
  };
}
