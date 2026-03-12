{
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.home.dms;
in {
  imports = [
    inputs.dms.homeModules.default
    inputs.dms.homeModules.niri
  ];

  options.modules.home.dms = with lib; {
    enable = mkEnableOption "DankMaterialShell";
  };

  config = lib.mkIf cfg.enable {
    programs.dank-material-shell = {
      enable = true;

      settings = {
        # Theme
        currentThemeName = "dynamic";
        matugenScheme = "scheme-tonal-spot";

        # Lockscreen
        lockBeforeSuspend = true;

        # Auto-location for weather and time
        useAutoLocation = true;
      };
    };
  };
}
