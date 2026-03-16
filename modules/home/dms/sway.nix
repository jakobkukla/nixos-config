{
  lib,
  config,
  osConfig,
  ...
}: let
  cfg = config.modules.home.dms;
in {
  config = lib.mkIf (cfg.enable && osConfig.modules.windowManager.sway.enable) {
    wayland.windowManager.sway.config = {
      # Startup
      startup = [
        {command = "dms run";}
      ];

      # Keybinds
      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in
        lib.mkOptionDefault {
          "${modifier}+space" = "exec dms ipc spotlight toggle";
          "${modifier}+n" = "exec dms ipc notifications toggle";
          "${modifier}+comma" = "exec dms ipc settings toggle";
          "${modifier}+p" = "exec dms ipc notepad toggle";
          "Mod4+Alt+l" = "exec dms ipc lock lock";
          "${modifier}+x" = "exec dms ipc powermenu toggle";
          "${modifier}+v" = "exec dms ipc clipboard toggle";
          "${modifier}+Alt+n" = "exec dms ipc night toggle";

          "XF86AudioMute" = "exec dms ipc audio mute";
          "XF86AudioMicMute" = "exec dms ipc audio micmute";
          "XF86AudioRaiseVolume" = "exec dms ipc audio increment 3";
          "XF86AudioLowerVolume" = "exec dms ipc audio decrement 3";
          "XF86MonBrightnessUp" = "exec dms ipc brightness increment 5 ''";
          "XF86MonBrightnessDown" = "exec dms ipc brightness decrement 5 ''";
        };
    };
  };
}
