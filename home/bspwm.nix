{ pkgs, ... }:

{
  home-manager.users.jakob = {
    home.pointerCursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = 48;

      x11.enable = true;
      gtk.enable = true;
    };

    xsession = {
      enable = true;

      windowManager.bspwm = {
        enable = true;
        extraConfig = ''
          bspc monitor -d I II III IV V VI VII VIII IX X
        '';
        startupPrograms = [
          #"dunst"
          #"wmname LG3D" # Java Applications Fix (Intellij IDEA)
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
        };
      };
    };

    home.sessionVariables = {
      _JAVA_AWT_WM_NONREPARENTING = 1; # Fix java non-parenting issues
    };
  };
}

