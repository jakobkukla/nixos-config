{
  lib,
  pkgs,
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
      # FIXME: remove once https://github.com/NixOS/nixpkgs/pull/396637 is merged
      package = pkgs.librespot.override {withAvahi = true;};

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
