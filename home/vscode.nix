{ pkgs, ... }:

{
  home-manager.users.jakob = {
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        ms-dotnettools.csharp
        ms-azuretools.vscode-docker
        james-yu.latex-workshop
        valentjn.vscode-ltex # Latex spell checking
        ocamllabs.ocaml-platform
      ];
      userSettings = {
        "window.menuBarVisibility" = "toggle";
        "omnisharp.path" = "/home/jakob/.nix-profile/bin/omnisharp";
        "ltex.language" = "de-DE";
      };
    };

    home.packages = with pkgs; [
      omnisharp-roslyn
      ocamlPackages.ocaml-lsp
      ocamlformat
    ];
  };
}
