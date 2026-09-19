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
    sessionCommand = mkOption {
      type = types.str;
      internal = true;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.modules.desktopEnvironment.enable;
        message = "`modules.desktopEnvironment` must be enabled to use the sway compositor";
      }
    ];

    modules.desktopEnvironment.compositors.sway.sessionCommand =
      lib.getExe config.home-manager.users.${config.modules.user.name}.wayland.windowManager.sway.package;

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

          output = {
            eDP-1 = {
              scale = "2";
            };
          };

          input = {
            "type:keyboard" = {
              xkb_layout = "de";
              xkb_variant = "nodeadkeys";
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
              "${modifier}+Shift+b" = "exec ${commands.passwordManager}";

              "XF86MonBrightnessUp" = "exec ${commands.brightnessUp}";
              "XF86MonBrightnessDown" = "exec ${commands.brightnessDown}";
              "XF86AudioRaiseVolume" = "exec ${commands.volumeUp}";
              "XF86AudioLowerVolume" = "exec ${commands.volumeDown}";
              "XF86AudioMute" = "exec ${commands.volumeMute}";
            };
        };
      };
    };
  };
}
