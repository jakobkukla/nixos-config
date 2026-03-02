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
    inputs.dms-plugin-registry.modules.default
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

      managePluginSettings = true;
      plugins = {
        # TODO: Can I move this to the kde-connect module and enable it
        # conditionally?
        dankKDEConnect.enable = true;
      };
    };
  };
}
