{
  lib,
  config,
  ...
}: let
  cfg = config.modules.desktopEnvironment.compositors.niri;
  commands = config.modules.desktopEnvironment.commands;

  spawn = command: {spawn-sh = command;};
  spawnLocked = command: {
    _props.allow-when-locked = true;
    spawn-sh = command;
  };

  # binds Mod + [Shift +] {1..0} to [move to] workspace {1..10}
  workspaces = lib.mergeAttrsList (lib.map (i: let
      key = toString (lib.mod i 10);
    in {
      "Mod+${key}".focus-workspace = i;
      "Mod+Shift+${key}".move-column-to-workspace = i;
    })
    (lib.range 1 10));
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.modules.user.name} = {
      wayland.windowManager.niri.settings.binds =
        {
          # Show Keybinds
          "Mod+Shift+Ssharp".show-hotkey-overlay = {};

          "Mod+Return" = spawn commands.terminal;
          "Mod+D" = spawn commands.launcher;
          "Mod+Space" = spawn commands.spotlight;
          "Mod+Shift+B" = spawn commands.passwordManager;
          "Mod+N" = spawn commands.notifications;
          "Mod+Comma" = spawn commands.settings;
          "Mod+P" = spawn commands.notepad;
          "Mod+M" = spawn commands.processList;
          "Mod+Alt+L" = spawn commands.lock;
          "Mod+X" = spawn commands.powerMenu;
          "Mod+V" = spawn commands.clipboard;
          "Mod+Alt+N" = spawnLocked commands.nightMode;
          "Print" = spawn commands.screenshot;
          "Shift+Print" = spawn commands.screenshotFull;

          # Volume Keys
          XF86AudioRaiseVolume = spawnLocked commands.volumeUp;
          XF86AudioLowerVolume = spawnLocked commands.volumeDown;
          XF86AudioMute = spawnLocked commands.volumeMute;
          XF86AudioMicMute = spawnLocked commands.micMute;

          # Media Keys
          XF86AudioPlay = spawnLocked commands.mediaPlayPause;
          XF86AudioStop = spawnLocked commands.mediaStop;
          XF86AudioPrev = spawnLocked commands.mediaPrevious;
          XF86AudioNext = spawnLocked commands.mediaNext;

          # Backlight Brightness Keys
          XF86MonBrightnessUp = spawnLocked commands.brightnessUp;
          XF86MonBrightnessDown = spawnLocked commands.brightnessDown;

          #
          ## Window and Workspace Management
          #

          # Switch presets
          "Mod+R".switch-preset-column-width = {};

          # Toggle Overview
          "Mod+O" = {
            _props.repeat = false;
            toggle-overview = {};
          };

          # Close Window
          "Mod+Shift+Q" = {
            _props.repeat = false;
            close-window = {};
          };

          # Focus Window
          "Mod+H".focus-column-left = {};
          "Mod+J".focus-window-down = {};
          "Mod+K".focus-window-up = {};
          "Mod+L".focus-column-right = {};

          # Move Window
          "Mod+Shift+H".move-column-left = {};
          "Mod+Shift+J".move-window-down = {};
          "Mod+Shift+K".move-window-up = {};
          "Mod+Shift+L".move-column-right = {};

          # Focus Workspace
          "Mod+U".focus-workspace-down = {};
          "Mod+I".focus-workspace-up = {};
          "Mod+WheelScrollDown" = {
            _props.cooldown-ms = 150;
            focus-workspace-down = {};
          };
          "Mod+WheelScrollUp" = {
            _props.cooldown-ms = 150;
            focus-workspace-up = {};
          };

          # Move to Workspace
          "Mod+Shift+U".move-column-to-workspace-down = {};
          "Mod+Shift+I".move-column-to-workspace-up = {};
          "Mod+Shift+WheelScrollDown" = {
            _props.cooldown-ms = 150;
            move-column-to-workspace-down = {};
          };
          "Mod+Shift+WheelScrollUp" = {
            _props.cooldown-ms = 150;
            move-column-to-workspace-up = {};
          };

          # Move Workspace
          "Mod+Ctrl+U".move-workspace-down = {};
          "Mod+Ctrl+I".move-workspace-up = {};

          # Maximize Window
          "Mod+F".maximize-column = {};
          # Toggle Fullscreen
          "Mod+Shift+F".fullscreen-window = {};
          # Expand Window to available space
          "Mod+Ctrl+F".expand-column-to-available-width = {};
          # Center Window
          "Mod+C".center-column = {};
          # Center Visible Windows
          "Mod+Shift+C".center-visible-columns = {};
        }
        // workspaces;
    };
  };
}
