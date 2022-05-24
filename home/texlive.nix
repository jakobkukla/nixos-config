{ pkgs, ... }:

{
  home-manager.users.jakob = {
    home.packages = with pkgs; [
      texlive.combined.scheme-medium
    ];
  };
}
