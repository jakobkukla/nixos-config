{
  lib,
  config,
  osConfig,
  ...
}: let
  cfg = config.modules.home.dms;
in {
  config = lib.mkIf (cfg.enable && osConfig.modules.windowManager.hyprland.enable) {
    wayland.windowManager.hyprland.settings = {
      #
      ## Startup
      #
      exec-once = ["dms run"];

      #
      ## Keybinds
      #
      bind = [
        "$mod, SPACE, exec, dms ipc spotlight toggle"
        "$mod, N, exec, dms ipc notifications toggle"
        "$mod, COMMA, exec, dms ipc settings toggle"
        "$mod, P, exec, dms ipc notepad toggle"
        "SUPER ALT, L, exec, dms ipc lock lock"
        "$mod, X, exec, dms ipc powermenu toggle"
        "$mod, V, exec, dms ipc clipboard toggle"
      ];

      bindl = [
        "$mod ALT, N, exec, dms ipc night toggle"

        # volume
        ", XF86AudioMute, exec, dms ipc audio mute"
        ", XF86AudioMicMute, exec, dms ipc audio micmute"
      ];

      bindle = [
        # volume
        ", XF86AudioRaiseVolume, exec, dms ipc audio increment 3"
        ", XF86AudioLowerVolume, exec, dms ipc audio decrement 3"

        # backlight
        ", XF86MonBrightnessUp, exec, dms ipc brightness increment 5 ''"
        ", XF86MonBrightnessDown, exec, dms ipc brightness decrement 5 ''"
      ];
    };
  };
}
