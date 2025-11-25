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
      type = types.attrsOf (types.submodule {
        options = {
          resolution = mkOption {
            type = types.str;
          };
          position = mkOption {
            type = types.str;
          };
          scale = mkOption {
            type = types.str;
          };
          disableOnLidSwitch = mkOption {
            type = types.bool;
            default = false;
            example = true;
            description = ''
              Whether to disable this is monitor when the laptop lid is closed.
            '';
          };
        };
      });
      default = {};
      example = literalExpression ''
        {
          "DP-1" = {
            resolution = "2560x1440@144";
            position = "0x0";
            scale = "1";
          };

          # Define a fallback rule (equivalent to ", preferred, auto, auto")
          "" = {
            resolution = "preferred";
            position = "auto";
            scale = "auto";
          };
        }
      '';
      description = ''
        Attribute set mapping to Hyprland monitor configurations.

        See <https://wiki.hypr.land/Configuring/Monitors/>
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

  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;

    # FIXME: Shouldn't be needed. See https://discourse.nixos.org/t/unable-to-add-new-library-folder-to-steam/38923/10
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    };

    home-manager.users.${config.modules.user.name} = {
      home.packages = with pkgs; [
        wl-clipboard
        # hyprland screenshot utility
        grimblast
      ];

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
        plugins = with pkgs.hyprlandPlugins; [
          csgo-vulkan-fix
        ];
      };
    };
  };
}
