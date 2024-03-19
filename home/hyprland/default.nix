{
  inputs,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.jakob = {
    imports = [
      ./binds.nix
      ./settings.nix
    ];

    home.packages = [
      pkgs.wl-clipboard
      # hyprland screenshot utility
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    ];

    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1"; # Fix java non-parenting issues
    };

    home.pointerCursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";

      gtk.enable = true;
      size = 24;
    };

    gtk.enable = true;

    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = /home/jakob/Pictures/wp.jpg
      wallpaper = , /home/jakob/Pictures/wp.jpg
    '';

    systemd.user.services.hyprpaper = {
      Unit = {
        Description = "Hyprland wallpaper daemon";
        PartOf = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${lib.getExe inputs.hyprpaper.packages.${pkgs.system}.default}";
        Restart = "on-failure";
      };
      Install.WantedBy = ["graphical-session.target"];
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

    # start swayidle as part of hyprland, not sway
    systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];

    wayland.windowManager.hyprland = {
      enable = true;

      systemd = {
        variables = ["--all"];
      };
    };
  };
}
