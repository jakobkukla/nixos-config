{ pkgs, ... }:

{
  home-manager.users.jakob = {
    xsession = {
      enable = true;

      # warning: jakob profile: GTK cursor settings will no longer be handled in the xsession.pointerCursor module in future.
      # Please use gtk.cursorTheme for GTK cursor settings instead.

      # warning: jakob profile: The option `xsession.pointerCursor` has been merged into `home.pointerCursor` and will be removed
      # in the future. Please change to set `home.pointerCursor` directly and enable `home.pointerCursor.x11.enable`
      # to generate x11 specific cursor configurations. You can refer to the documentation for more details.

      pointerCursor = {
        package = pkgs.gnome.adwaita-icon-theme;
        name = "Adwaita";
        size = 48;
      };

      windowManager.bspwm = {
        enable = true;
        extraConfig = ''
          bspc monitor -d I II III IV V VI VII VIII IX X
        '';
        startupPrograms = [
          #"dunst"
          #"wmname LG3D" # Java Applications Fix (Intellij IDEA)
          "wal -R"
        ];
	rules = {
	  "Zathura" = {
	    state = "tiled";
          };

          "Emacs" = {
	    state = "tiled";
          };
	};
        settings = {
          border_width = 8;
          window_gap = 20;

          split_ratio = 0.52;
          borderless_monocle = true;
          gapless_monocle = true;

          normal_border_color = "$color15";
          active_border_color = "$color2";
          focused_border_color = "$color5";
          presel_feedback_color = "$color15";

  #        #
  #        ### Pywal
  #        #
  #       . "${HOME}/.cache/wal/colors.sh"
        };
      };
    };

    home.sessionVariables = {
      _JAVA_AWT_WM_NONREPARENTING = 1; # Fix java non-parenting issues
    };

    programs.rofi = {
      enable = true;
    };
  };
}

