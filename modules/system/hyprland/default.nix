{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.hyprland;
in {
  imports = [
    ./binds.nix
    ./settings.nix
    ./hyprpaper.nix
  ];

  options.modules.hyprland = with lib; {
    enable = mkEnableOption "Hyprland window manager";
    enableNaturalScroll = mkEnableOption "natural scrolling";
    enableTearing = mkEnableOption "tearing support (for cs2)";

    monitors = mkOption {
      type = types.listOf types.str;
      default = [];
      example = literalExpression ''
        [
          "DP-1,2560x1440@144,0x0,1"
        ]
      '';
      description = ''
        List of hyprland monitor configurations.
      '';
    };

    wallpapers = mkOption {
      type = types.listOf types.str;
      default = [];
      example = literalExpression ''
        [
          "DP-1,/path/to/wallpaper1.png"
          "DP-2,/path/to/wallpaper2.png"
        ]
      '';
      description = ''
        List of hyprpaper wallpaper configurations.
      '';
    };
  };

  config = let
    # FIXME: This is needed to source home.sessionVariables in Hyprland.
    # Keep track of https://github.com/nix-community/home-manager/issues/2659 for a cleaner solution.
    hyprlandWrapper = pkgs.writeShellScript "hyprland_wrapper" ''
      source "${config.modules.user.homeDirectory}/.nix-profile/etc/profile.d/hm-session-vars.sh"

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
        home.packages = with pkgs; [
          wl-clipboard
          # hyprland screenshot utility
          grimblast
        ];

        home.sessionVariables = {
          NIXOS_OZONE_WL = "1";
          _JAVA_AWT_WM_NONREPARENTING = "1"; # Fix java non-parenting issues
        };

        home.pointerCursor = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";

          gtk.enable = true;
          size = 24;
        };

        gtk.enable = true;

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

        services.gammastep = {
          enable = true;
          # provider = "geoclue2";
          latitude = 52.5200;
          longitude = 13.4050;
        };

        wayland.windowManager.hyprland = {
          enable = true;
          systemd.variables = ["--all"];
        };
      };
    };
}
