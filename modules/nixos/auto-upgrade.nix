{
  lib,
  config,
  ...
}: let
  cfg = config.modules.autoUpgrade;
in {
  options.modules.autoUpgrade = with lib; {
    enable = mkEnableOption "automatic NixOS upgrades from the stable branch";
  };

  config = lib.mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      flake = "github:jakobkukla/nixos-config/stable";

      dates = "09:15";
      randomizedDelaySec = "15min";
      fixedRandomDelay = true;

      upgrade = false;
      # Fail on any non-cached build jobs.
      flags = [
        "--max-jobs"
        "0"
        "--option"
        "always-allow-substitutes"
        "true"
      ];

      allowReboot = true;
      rebootWindow = {
        lower = "08:30";
        upper = "10:15";
      };

      runGarbageCollection = true;
    };
  };
}
