{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  cfg = config.modules.hyprland;
in {
  options.modules.hyprland = with lib; {
    enable = mkEnableOption "Hyprland window manager";
  };

  config = let
    # FIXME: This is needed to source home.sessionVariables in Hyprland.
    # Keep track of https://github.com/nix-community/home-manager/issues/2659 for a cleaner solution.
    hyprlandWrapper = pkgs.writeShellScript "hyprland_wrapper" ''
      source "/home/${config.modules.user.name}/.nix-profile/etc/profile.d/hm-session-vars.sh"

      exec ${lib.getExe config.programs.hyprland.package} $@
    '';
  in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = !config.modules.sway.enable;
          message = "`sway` and `hyprland` modules must not be enabled at the same time";
        }
      ];

      modules.greetd = {
        enable = true;
        command = hyprlandWrapper.outPath;
        user = config.modules.user.name;
      };

      programs.hyprland.enable = true;

      home-manager.users.${config.modules.user.name} = {
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
          preload = /home/${config.modules.user.name}/Pictures/wp.jpg
          wallpaper = , /home/${config.modules.user.name}/Pictures/wp.jpg
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

        modules.home.rofi.enable = true;

        wayland.windowManager.hyprland = {
          enable = true;
          systemd.variables = ["--all"];
        };
      };
    };
}
