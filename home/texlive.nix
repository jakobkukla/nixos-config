{ pkgs, ... }:

{
  home-manager.users.jakob = {
    home.packages = with pkgs; [
      #texlive.combined.scheme-medium
      (texlive.combine { inherit (texlive) scheme-medium biblatex biblatex-apa; })
      biber
    ];
  };
}
