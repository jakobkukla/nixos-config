{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.niri;
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.modules.user.name} = {
      programs.niri.settings.binds = with config.home-manager.users.${config.modules.user.name}.lib.niri.actions;
        lib.mkMerge [
          {
            # Show Keybinds
            # FIXME: doesnt work? I want it at Mod+?.
            # "Mod+Shift+ß".action = show-hotkey-overlay;
            "Mod+Shift+Ssharp".action = show-hotkey-overlay;

            # Open Terminal
            "Mod+Return" = {
              hotkey-overlay.title = "Open a Terminal: alacritty";
              action.spawn = "${lib.getExe pkgs.alacritty}";
            };
            # Open Runner
            "Mod+D" = {
              hotkey-overlay.title = "Run an Application: rofi";
              action.spawn-sh = "${lib.getExe pkgs.rofi} -m 1 -show drun";
            };

            # Volume Keys
            # FIXME: these are defined by DMS
            # XF86AudioRaiseVolume = {
            #   allow-when-locked=true;
            #   action.spawn-sh = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 6%+ -l '1.0'";
            # };
            # XF86AudioLowerVolume = {
            #   allow-when-locked=true;
            #   action.spawn-sh = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 6%-";
            # };
            # XF86AudioMute = {
            #   allow-when-locked=true;
            #   action.spawn-sh = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
            # };
            # XF86AudioMicMute = {
            #   allow-when-locked=true;
            #   action.spawn-sh = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            # };

            # Media Keys
            XF86AudioPlay = {
              allow-when-locked = true;
              action.spawn-sh = "${lib.getExe pkgs.playerctl} play-pause";
            };
            XF86AudioStop = {
              allow-when-locked = true;
              action.spawn-sh = "${lib.getExe pkgs.playerctl} stop";
            };
            XF86AudioPrev = {
              allow-when-locked = true;
              action.spawn-sh = "${lib.getExe pkgs.playerctl} previous";
            };
            XF86AudioNext = {
              allow-when-locked = true;
              action.spawn-sh = "${lib.getExe pkgs.playerctl} playerctl next";
            };

            # Backlight Brightness Keys
            # TODO: consider switching to brightnessctl
            # FIXME: these are defined by DMS
            # XF86MonBrightnessUp = {
            #   allow-when-locked=true;
            #   action.spawn-sh = "${lib.getExe pkgs.light} -A 10";
            # };
            # XF86MonBrightnessDown = {
            #   allow-when-locked=true;
            #   action.spawn-sh = "${lib.getExe pkgs.light} -U 10";
            # };

            #
            ## Window and Workspace Management
            #

            # Toggle Overview
            "Mod+O" = {
              repeat = false;
              action = toggle-overview;
            };

            # Close Window
            "Mod+Shift+Q" = {
              repeat = false;
              action = close-window;
            };

            # Focus Window
            "Mod+H".action = focus-column-left;
            "Mod+J".action = focus-window-down;
            "Mod+K".action = focus-window-up;
            "Mod+L".action = focus-column-right;

            # Move Window
            "Mod+Shift+H".action = move-column-left;
            "Mod+Shift+J".action = move-window-down;
            "Mod+Shift+K".action = move-window-up;
            "Mod+Shift+L".action = move-column-right;

            # Focus Workspace
            "Mod+U".action = focus-workspace-down;
            "Mod+I".action = focus-workspace-up;
            "Mod+WheelScrollDown" = {
              cooldown-ms = 150;
              action = focus-workspace-down;
            };
            "Mod+WheelScrollUp" = {
              cooldown-ms = 150;
              action = focus-workspace-up;
            };

            # Move to Workspace
            "Mod+Shift+U".action = move-column-to-workspace-down;
            "Mod+Shift+I".action = move-column-to-workspace-up;
            "Mod+Shift+WheelScrollDown" = {
              cooldown-ms = 150;
              action = move-column-to-workspace-down;
            };
            "Mod+Shift+WheelScrollUp" = {
              cooldown-ms = 150;
              action = move-column-to-workspace-up;
            };

            # Move Workspace
            "Mod+Ctrl+U".action = move-workspace-down;
            "Mod+Ctrl+I".action = move-workspace-up;

            # Toggle Fullscreen
            "Mod+F".action = fullscreen-window;
            # Maximize Window
            "Mod+Shift+F".action = maximize-column;
            # Expand Window to available space
            "Mod+Ctrl+F".action = expand-column-to-available-width;
            # Center Window
            "Mod+C".action = center-column;
            # Center Visible Windows
            "Mod+Shift+C".action = center-visible-columns;

            # TODO: continue from https://github.com/YaLTeR/niri/blob/main/resources/default-config.kdl#L372
            # TODO: bitwarden
          }

          (lib.mkMerge (lib.map (i: {
            # Focus + Move to Workspace with Index
            # FIXME: how can the first work, but not the second?
            "Mod+${toString i}".action = focus-workspace i;
            "Mod+Shift+${toString i}".action.move-column-to-workspace = i;
          }) (lib.range 1 9)))
        ];
    };
  };
}
