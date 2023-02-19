{pkgs, ...}: {
  home-manager.users.jakob = {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
  };
}
