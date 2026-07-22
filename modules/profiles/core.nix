{
  lib,
  config,
  ...
}: let
  cfg = config.profiles.core;
in {
  options.profiles.core = with lib; {
    enable = mkEnableOption "core profile";
  };

  config = lib.mkIf cfg.enable {
    security.polkit.enable = true;
  };
}
