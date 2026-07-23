{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.home.languages.latex;
in {
  options.modules.home.languages.latex = with lib; {
    enable = mkEnableOption "LaTeX typesetting system";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      texliveFull
      # language server
      texlab
      # another language server
      ltex-ls
    ];
  };
}
