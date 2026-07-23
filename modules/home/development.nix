{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.home.development;
in {
  options.modules.home.development = with lib; {
    enable = mkEnableOption "development tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # IDEs
      android-studio

      # ADB
      android-tools
    ];

    modules.home = {
      languages.latex.enable = true;
      vscode.enable = true;
    };
  };
}
