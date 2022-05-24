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
      ];
      userSettings = {
         "window.menuBarVisibility" = "toggle";
         "omnisharp.path" = "/home/jakob/.nix-profile/bin/omnisharp";
      };
    };

    home.packages = with pkgs; [
      omnisharp-roslyn
    ];
  };
}
