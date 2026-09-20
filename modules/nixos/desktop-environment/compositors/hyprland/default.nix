{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.desktopEnvironment.compositors.hyprland;
in {
  imports = [
    ./binds.nix
    ./hyprpaper.nix
    ./settings.nix
  ];

  options.modules.desktopEnvironment.compositors.hyprland = with lib; {
    enable = mkEnableOption "Hyprland compositor";
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
    assertions = [
      {
        assertion = config.modules.desktopEnvironment.enable;
        message = "`modules.desktopEnvironment` must be enabled to use the hyprland compositor";
      }
    ];

    programs.hyprland.enable = true;

    home-manager.users.${config.modules.user.name} = {
      wayland.windowManager.hyprland = {
        enable = true;
        # TODO: port config to lua (default as of home.stateVersion >= 26.05)
        configType = "hyprlang";
        systemd.variables = ["--all"];
        plugins = with pkgs.hyprlandPlugins; [
          csgo-vulkan-fix
        ];
      };
    };
  };
}
