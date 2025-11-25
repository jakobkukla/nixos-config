{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.windowManager;
in {
  options.modules.windowManager = with lib; {
    enable = mkEnableOption "Wayland window manager configuration";

    variant = mkOption {
      type = types.enum ["hyprland" "niri"];
      example = "niri";
      description = ''
        Name of the window-manager to use.
      '';
    };
  };

  config = let
    startCommands = {
      # FIXME: This is needed to source home.sessionVariables in Hyprland.
      # Keep track of https://github.com/nix-community/home-manager/issues/2659 for a cleaner solution.
      hyprland = pkgs.writeShellScript "hyprland_wrapper" ''
        source "${config.modules.user.homeDirectory}/.nix-profile/etc/profile.d/hm-session-vars.sh"

        exec ${lib.getExe config.programs.hyprland.package} $@
      '';

      niri = "niri-session";
    };
  in
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = let
              countEnabled =
                builtins.length (builtins.filter (x: x)
                  [config.modules.sway.enable config.modules.hyprland.enable config.modules.niri.enable]);
            in
              countEnabled <= 1;
            message = "At most one window manager (sway, hyprland, or niri) may be enabled at the same time.";
          }
        ];
      }

      (lib.mkIf (cfg.enable && cfg.variant == "hyprland") {
        modules.hyprland.enable = true;
      })

      (lib.mkIf (cfg.enable && cfg.variant == "niri") {
        modules.niri.enable = true;
      })

      (lib.mkIf cfg.enable {
        modules.greetd = {
          enable = true;
          command = startCommands.${cfg.variant};
          user = config.modules.user.name;
        };

        # TODO: think about moving this to modules.greetd (or modules.greetd in here?)
        # FIXME: also this is (as of now) not WM agnostic
        services.displayManager.dms-greeter = {
          enable = true;
          compositor.name = cfg.variant;
          configHome = config.modules.user.homeDirectory;
        };

        home-manager.users.${config.modules.user.name} = {
          home.packages = with pkgs; [
            wl-clipboard
          ];

          home.sessionVariables = {
            # Enable wayland backend for chromium/electron applications
            NIXOS_OZONE_WL = "1";
            # Fix java blank-screen issues for xwayland-satellite
            _JAVA_AWT_WM_NONREPARENTING = "1";
          };

          home.pointerCursor = {
            enable = true;
            package = pkgs.adwaita-icon-theme;

            name = "Adwaita";
            size = 24;

            x11.enable = true;
            gtk.enable = true;
          };

          # TODO: configure input and output devices here:
          # libinput
          # kanshi

          # TODO: FROM HERE: do I want this / need these
          # modules.home.rofi.enable = true;

          # services.gammastep = {
          #   enable = true;
          #   # provider = "geoclue2";
          #   latitude = 52.5200;
          #   longitude = 13.4050;
          # };
        };
      })
    ];
}
