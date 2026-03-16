{
  lib,
  config,
  osConfig,
  inputs,
  ...
}: let
  cfg = config.modules.home.dms;
in {
  imports = [
    inputs.dms.homeModules.niri
  ];

  config = lib.mkIf (cfg.enable && osConfig.modules.windowManager.niri.enable) {
    programs.dank-material-shell.niri = {
      enableKeybinds = true;
      enableSpawn = true;
    };
  };
}
