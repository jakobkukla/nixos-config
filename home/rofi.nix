{ ... }:

{
  home-manager.users.jakob = {
    programs.rofi = {
      enable = true;
      extraConfig.dpi = 192;
      theme = "~/.cache/wal/colors-rofi-dark.rasi";
    };
  };
}
