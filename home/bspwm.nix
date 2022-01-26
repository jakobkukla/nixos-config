{ pkgs, ... }:

{
  home-manager.users.jakob = {
    xsession = {
      enable = true;

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

    programs.rofi = {
      enable = true;
    };
  };
}

