{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.home.vscode;
in {
  options.modules.home.vscode = with lib; {
    enable = mkEnableOption "Visual Studio Code";
    enableLatex =
      mkEnableOption "LaTeX integration"
      // {
        default = config.modules.home.languages.latex.enable;
      };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enableLatex -> config.modules.home.languages.latex.enable;
        message = "Option `enableLatex` requires `modules.home.languages.latex.enable` set to true";
      }
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhs;

      profiles.default = {
        extensions = with pkgs.vscode-extensions;
          [
            vscodevim.vim
            ms-azuretools.vscode-docker
            bbenoist.nix # nix language support
            mkhl.direnv
          ]
          ++ lib.optionals cfg.enableLatex [
            james-yu.latex-workshop
            valentjn.vscode-ltex # Latex spell checking
          ];

        userSettings = lib.mkMerge [
          {
            "window.menuBarVisibility" = "toggle";
          }

          (lib.mkIf cfg.enableLatex {
            "ltex.language" = "en-US";
          })
        ];
      };
    };
  };
}
