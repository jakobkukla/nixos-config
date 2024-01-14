{
  pkgs,
  lib,
  ...
}: {
  home-manager.users.jakob = {
    home.packages = with pkgs; [
      wl-clipboard
    ];

    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1"; # Fix java non-parenting issues
    };

    # FIXME: This is needed to source home.sessionVariables in LightDM (and probably most other DMs).
    # Keep track of https://github.com/nix-community/home-manager/issues/2659 for a cleaner solution.
    xsession.enable = true;

    home.pointerCursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";

      gtk.enable = true;
    };

    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 1200;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };

    services.gammastep = {
      enable = true;
      provider = "geoclue2";
    };

    wayland.windowManager.sway = {
      enable = true;

      # fix xdg-open with xdgOpenUsePortals in sway (see https://github.com/NixOS/nixpkgs/issues/160923#issuecomment-1627438735)
      extraSessionCommands = ''
        dbus-update-activation-environment --systemd --all
      '';

      config = {
        modifier = "Mod4";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        menu = "${pkgs.rofi-wayland}/bin/rofi -m 1 -show drun | xargs swaymsg exec --";

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
            natural_scroll = "enabled";
          };
        };

        gaps = {
          inner = 15;
        };

        keybindings = lib.mkOptionDefault {
          "XF86MonBrightnessUp" = "exec light -A 10";
          "XF86MonBrightnessDown" = "exec light -U 10";
          "XF86AudioRaiseVolume" = "exec wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+";
          "XF86AudioLowerVolume" = "exec wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
      };
    };
  };
}
