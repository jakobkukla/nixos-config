{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.hyprland;

  # workspaces
  # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  workspaces = builtins.concatLists (builtins.genList (
      x: let
        ws = let
          c = (x + 1) / 10;
        in
          builtins.toString (x + 1 - (c * 10));
      in [
        "$mod, ${ws}, workspace, ${toString (x + 1)}"
        "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
      ]
    )
    10);
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.modules.user.name} = {
      wayland.windowManager.hyprland.settings = {
        "$terminal" = "${pkgs.alacritty}/bin/alacritty";
        "$menu" = "${pkgs.rofi}/bin/rofi -m 1 -show drun";
        "$bitwarden" = "${pkgs.rofi-rbw-wayland}/bin/rofi-rbw";

        "$mod" = "SUPER";

        # Home row direction keys
        "$left" = "H";
        "$down" = "J";
        "$up" = "K";
        "$right" = "L";

        bindl =
          [
            # volume
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ]
          ++ (
            let
              internalMonitors = lib.filterAttrs (_: cfg: cfg.isInternal) cfg.monitors;
            in
              # disable/enable monitor on lid switch
              lib.concatLists (lib.mapAttrsToList (
                  monitor: cfg: let
                    monitorConfigString = "${monitor},${cfg.resolution},${cfg.position},${cfg.scale}";
                  in [
                    # FIXME: get lid switch name programmatically
                    ", switch:on:Lid Switch, exec, hyprctl keyword monitor '${monitor}, disable'"
                    ", switch:off:Lid Switch, exec, hyprctl keyword monitor '${monitorConfigString}'"
                  ]
                )
                internalMonitors)
          );

        bindle = [
          # volume
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"

          # backlight
          ", XF86MonBrightnessUp, exec, light -A 10"
          ", XF86MonBrightnessDown, exec, light -U 10"
        ];

        bind =
          [
            "$mod, $left, movefocus, l"
            "$mod, $right, movefocus, r"
            "$mod, $up, movefocus, u"
            "$mod, $down, movefocus, d"

            "$mod SHIFT, $left, movewindow, l"
            "$mod SHIFT, $right, movewindow, r"
            "$mod SHIFT, $up, movewindow, u"
            "$mod SHIFT, $down, movewindow, d"

            "$mod, RETURN, exec, $terminal"
            "$mod, D, exec, $menu"
            "$mod, F, fullscreen,"
            "$mod SHIFT, Q, killactive,"

            "$mod SHIFT, B, exec, $bitwarden"
          ]
          ++ workspaces;
      };
    };
  };
}
