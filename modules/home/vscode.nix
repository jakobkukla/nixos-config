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
    enableServer =
      mkEnableOption "VSCode server and remote ssh"
      // {
        default = true;
      };
    enableOcaml =
      mkEnableOption "OCaml integration"
      // {
        default = config.modules.home.languages.ocaml.enable;
      };
    enableLatex =
      mkEnableOption "LaTeX integration"
      // {
        default = config.modules.home.languages.latex.enable;
      };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enableOcaml -> config.modules.home.languages.ocaml.enable;
        message = "Option `enableOcaml` requires `modules.home.languages.ocaml.enable` set to true";
      }
      {
        assertion = cfg.enableLatex -> config.modules.home.languages.latex.enable;
        message = "Option `enableLatex` requires `modules.home.languages.latex.enable` set to true";
      }
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhs;

      extensions = with pkgs.vscode-extensions;
        [
          vscodevim.vim
          ms-azuretools.vscode-docker
          bbenoist.nix # nix language support
          mkhl.direnv
        ]
        ++ lib.optionals cfg.enableServer [
          ms-vscode-remote.remote-ssh
        ]
        ++ lib.optionals cfg.enableOcaml [
          ocamllabs.ocaml-platform
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

    services.vscode-server.enable = cfg.enableServer;
  };
}
