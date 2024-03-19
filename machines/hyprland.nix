{pkgs, ...}: {
  imports = [
    ./greetd.nix
  ];

  programs.hyprland.enable = true;
}
