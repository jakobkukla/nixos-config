{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.home.languages.ocaml;
in {
  options.modules.home.languages.ocaml = with lib; {
    enable = mkEnableOption "OCaml programming language";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ocaml
      ocamlformat
      ocamlPackages.ocaml-lsp
    ];
  };
}
