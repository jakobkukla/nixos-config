{ pkgs, ... }:

{
  home-manager.users.jakob = {
    xsession = {
      enable = true;

      # warning: jakob profile: GTK cursor settings will no longer be handled in the xsession.pointerCursor module in future.
      # Please use gtk.cursorTheme for GTK cursor settings instead.
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

