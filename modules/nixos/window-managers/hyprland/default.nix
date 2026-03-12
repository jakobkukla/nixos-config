{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.windowManager.hyprland;
in {
  imports = [
    ./binds.nix
    ./settings.nix
    ./hyprpaper.nix
  ];

  options.modules.windowManager.hyprland = with lib; {
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
    modules.windowManager.enable = true;

    programs.hyprland.enable = true;

    # FIXME: Shouldn't be needed. See https://discourse.nixos.org/t/unable-to-add-new-library-folder-to-steam/38923/10
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    };

    home-manager.users.${config.modules.user.name} = {
      gtk.enable = true;

      # FIXME: should this stay here, or generalize to window-managers?
      # start swayidle as part of hyprland, not sway
      systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];

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
