{pkgs, ...}: {
  wayland.windowManager.hyprland.settings = {
    "$terminal" = "${pkgs.alacritty}/bin/alacritty";
    "$menu" = "${pkgs.rofi-wayland}/bin/rofi -m 1 -show drun";

    misc.disable_hyprland_logo = "true";

    input = {
      kb_layout = "de";
      kb_variant = "nodeadkeys";

      natural_scroll = "true";
      sensitivity = "0.1";

      touchpad = {
        # doesn't work for some reason
        tap-to-click = "false";
        clickfinger_behavior = "true";
        disable_while_typing = "true";
      };
    };

    animation = "global, 0,,";
  };
}
