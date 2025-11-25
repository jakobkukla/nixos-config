{
  lib,
  config,
  ...
}: let
  cfg = config.modules.home.dms;
in {
  # FIXME: this triggers an infinite recursion?
  # imports = [
  # inputs.dankMaterialShell.homeModules.dankMaterialShell.default
  # ];

  options.modules.home.dms = with lib; {
    enable = mkEnableOption "DankMaterialShell";
  };

  config = lib.mkIf cfg.enable {
    programs.dankMaterialShell = {
      enable = true;

      # FIXME: this isn't working
      default.settings = {
        # Theme
        currentThemeName = "dynamic";
        matugenScheme = "scheme-neutral";

        # Auto-location for weather and time
        useAutoLocation = true;
      };
    };
  };
}
