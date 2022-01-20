{ ... }:

{
  home-manager.users.jakob.programs.firefox = {
    enable = true;

    profiles.main.settings = {
      # This fixes the go-back-on-right-click bug
      "ui.context_menus.after_mouseup" = true;
    };
  };
}
