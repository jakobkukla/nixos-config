{
  lib,
  config,
  ...
}: let
  cfg = config.modules.desktopEnvironment.compositors.sway;
  commands = config.modules.desktopEnvironment.commands;
in {
  options.modules.desktopEnvironment.compositors.sway = with lib; {
    enable = mkEnableOption "Sway compositor";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.modules.desktopEnvironment.enable;
        message = "`modules.desktopEnvironment` must be enabled to use the sway compositor";
      }
    ];

    # Sway config is managed by home-manager. This is needed for the DM and xdg-desktop-portal.
    programs.sway.enable = true;

    # Enable real-time capabilities for all programs run by the users group (in particular sway)
    security.pam.loginLimits = [
      {
        domain = "@users";
        item = "rtprio";
        type = "-";
        value = 1;
      }
    ];

    home-manager.users.${config.modules.user.name} = hmArgs: {
      wayland.windowManager.sway = {
        enable = true;

        # fix xdg-open with xdgOpenUsePortals in sway (see https://github.com/NixOS/nixpkgs/issues/160923#issuecomment-1627438735)
        # FIXME: currently not working as dbus-update-activation-environment is not in path
        #extraSessionCommands = ''
        #  dbus-update-activation-environment --systemd --all
        #'';

        config = {
          modifier = "Mod4";
          terminal = commands.terminal;
          menu = "${commands.launcher} | xargs swaymsg exec --";

          input = {
            "type:keyboard" = {
              xkb_layout = "de,us";
              xkb_variant = "nodeadkeys,";
              xkb_options = "grp:ctrls_toggle";
            };

            "type:touchpad" = {
              pointer_accel = "0.1";
              tap = "disabled";
              click_method = "clickfinger";
              dwt = "enabled";
              natural_scroll =
                if config.modules.desktopEnvironment.input.naturalScroll
                then "enabled"
                else "disabled";
            };
          };

          gaps = {
            inner = 15;
          };

          keybindings = let
            modifier = hmArgs.config.wayland.windowManager.sway.config.modifier;
          in
            lib.mkOptionDefault {
              "${modifier}+space" = "exec ${commands.spotlight}";
              "${modifier}+Shift+b" = "exec ${commands.passwordManager}";
              "${modifier}+n" = "exec ${commands.notifications}";
              "${modifier}+comma" = "exec ${commands.settings}";
              "${modifier}+p" = "exec ${commands.notepad}";
              "${modifier}+Alt+l" = "exec ${commands.lock}";
              "${modifier}+x" = "exec ${commands.powerMenu}";
              "${modifier}+v" = "exec ${commands.clipboard}";
              "${modifier}+m" = "exec ${commands.processList}";
              "${modifier}+Alt+n" = "exec ${commands.nightMode}";
              "Print" = "exec ${commands.screenshot}";
              "Shift+Print" = "exec ${commands.screenshotFull}";

              "XF86MonBrightnessUp" = "exec ${commands.brightnessUp}";
              "XF86MonBrightnessDown" = "exec ${commands.brightnessDown}";
              "XF86AudioRaiseVolume" = "exec ${commands.volumeUp}";
              "XF86AudioLowerVolume" = "exec ${commands.volumeDown}";
              "XF86AudioMute" = "exec ${commands.volumeMute}";
              "XF86AudioMicMute" = "exec ${commands.micMute}";
              "XF86AudioPlay" = "exec ${commands.mediaPlayPause}";
              "XF86AudioStop" = "exec ${commands.mediaStop}";
              "XF86AudioPrev" = "exec ${commands.mediaPrevious}";
              "XF86AudioNext" = "exec ${commands.mediaNext}";
            };
        };
      };
    };
  };
}
