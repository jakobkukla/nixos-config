{ ... }:

{
  home-manager.users.jakob = {
    programs.rofi = {
      enable = true;
      extraConfig.dpi = 192;
    };
  };
}
