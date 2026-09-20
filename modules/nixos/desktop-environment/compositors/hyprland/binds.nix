{
  lib,
  config,
  ...
}: let
  cfg = config.modules.desktopEnvironment.compositors.hyprland;
  commands = config.modules.desktopEnvironment.commands;

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
        "$terminal" = commands.terminal;
        "$menu" = commands.launcher;
        "$bitwarden" = commands.passwordManager;

        "$mod" = "SUPER";

        # Home row direction keys
        "$left" = "H";
        "$down" = "J";
        "$up" = "K";
        "$right" = "L";

        bindl =
          [
            # volume
            "$mod ALT, N, exec, ${commands.nightMode}"

            # volume
            ", XF86AudioMute, exec, ${commands.volumeMute}"
            ", XF86AudioMicMute, exec, ${commands.micMute}"
          ]
          ++ (
            let
              internalMonitors = lib.filterAttrs (_: cfg: cfg.disableOnLidSwitch) cfg.monitors;
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
          ", XF86AudioRaiseVolume, exec, ${commands.volumeUp}"
          ", XF86AudioLowerVolume, exec, ${commands.volumeDown}"

          # backlight
          ", XF86MonBrightnessUp, exec, ${commands.brightnessUp}"
          ", XF86MonBrightnessDown, exec, ${commands.brightnessDown}"
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
            "$mod, SPACE, exec, ${commands.spotlight}"
            "$mod, F, fullscreen,"
            "$mod SHIFT, Q, killactive,"

            "$mod SHIFT, B, exec, $bitwarden"
            "$mod, N, exec, ${commands.notifications}"
            "$mod, COMMA, exec, ${commands.settings}"
            "$mod, P, exec, ${commands.notepad}"
            "$mod ALT, L, exec, ${commands.lock}"
            "$mod, X, exec, ${commands.powerMenu}"
            "$mod, V, exec, ${commands.clipboard}"
            ", Print, exec, ${commands.screenshot}"
            "SHIFT, Print, exec, ${commands.screenshotFull}"
          ]
          ++ workspaces;
      };
    };
  };
}
