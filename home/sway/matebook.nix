{ lib, ... }:

{
  imports =
    [
      ./base.nix
    ];

  home-manager.users.jakob = {
    wayland.windowManager.sway = {
      config = {
        output = {
          eDP-1 = {
            scale = "2";
          };
        };

        input = {
          "type:touchpad" = {
            pointer_accel = "0.1";
            tap = "disabled";
            click_method = "clickfinger";
            dwt = "enabled";
            natural_scroll = "enabled";
          };
        };

        keybindings = lib.mkOptionDefault {
          "XF86MonBrightnessUp" = "exec light -A 10";
          "XF86MonBrightnessDown" = "exec light -U 10";
        };
      };
    };
  };
}

