{
  pkgs,
  vscode-server,
  ...
}: {
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
        bbenoist.nix # nix language support
        mkhl.direnv
        ms-vscode-remote.remote-ssh
      ];
      userSettings = {
        "window.menuBarVisibility" = "toggle";
        "omnisharp.path" = "/home/jakob/.nix-profile/bin/omnisharp";
        "ltex.language" = "de-DE";
      };
    };

    # Use vscode-server flake to get remote ssh working
    imports = [
      vscode-server.nixosModules.home
    ];
    services.vscode-server.enable = true;

    home.packages = with pkgs; [
      omnisharp-roslyn
      ocamlPackages.ocaml-lsp
      ocamlformat
    ];
  };
}
