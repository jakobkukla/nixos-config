{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.windowManager.sway;
in {
  options.modules.windowManager.sway = with lib; {
    enable = mkEnableOption "Sway window manager";
    enableNaturalScroll = mkEnableOption "natural scrolling";
  };

  config = lib.mkIf cfg.enable {
    modules.windowManager.enable = true;

    # Sway config is managed by home-manager. This is needed for the DM and xdg-desktop-portal.
    programs.sway.enable = true;

    # Enable xdg-desktop-portal
    services.dbus.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      # fix xdg-open in FHS or wrappers (see https://github.com/NixOS/nixpkgs/issues/160923)
      xdgOpenUsePortal = true;
      # gtk portal needed to make gtk apps happy
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

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
          terminal = "${pkgs.alacritty}/bin/alacritty";
          menu = "${pkgs.rofi}/bin/rofi -m 1 -show drun | xargs swaymsg exec --";

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
                if cfg.enableNaturalScroll
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
              "${modifier}+Shift+b" = "exec ${pkgs.rofi-rbw-wayland}/bin/rofi-rbw";

              # Make these overridable for DMS
              "XF86MonBrightnessUp" = lib.mkDefault "exec brightnessctl set +10%";
              "XF86MonBrightnessDown" = lib.mkDefault "exec brightnessctl set 10%-";
              "XF86AudioRaiseVolume" = lib.mkDefault "exec wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+";
              "XF86AudioLowerVolume" = lib.mkDefault "exec wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-";
              "XF86AudioMute" = lib.mkDefault "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            };
        };
      };
    };
  };
}
