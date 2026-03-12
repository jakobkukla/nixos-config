{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.windowManager;
in {
  imports = [
    ./hyprland
    ./sway.nix
  ];

  options.modules.windowManager = with lib; {
    enable = mkEnableOption "Wayland window manager configuration";

    default = mkOption {
      type = types.enum ["hyprland" "sway"];
      example = "hyprland";
      description = ''
        The default window manager variant to use.
      '';
    };
  };

  # FIXME: we allow using multiple WMs (which is nice): but what about WM specific configuration?
  # Say sway enables dunst but niri uses DMS as notification daemon. they will conflict...
  config = let
    startCommands = {
      # FIXME: This is needed to source home.sessionVariables in Hyprland.
      # Keep track of https://github.com/nix-community/home-manager/issues/2659 for a cleaner solution.
      hyprland =
        (pkgs.writeShellScript "hyprland_wrapper" ''
          source "${config.modules.user.homeDirectory}/.nix-profile/etc/profile.d/hm-session-vars.sh"

          exec ${lib.getExe config.programs.hyprland.package} $@
        '').outPath;
    };
  in
    lib.mkMerge [
      (lib.mkIf cfg.enable {
        assertions = [
          {
            assertion = config.modules.windowManager.${cfg.default}.enable;
            message = "\"${cfg.default}\" is configured as the default window manager but is not enabled";
          }
        ];

        modules.greetd = {
          enable = true;
          command = startCommands.${cfg.default};
          user = config.modules.user.name;
        };

        home-manager.users.${config.modules.user.name} = {
          home.packages = with pkgs; [
            # clipboard utility
            wl-clipboard
            # FIXME: think about replacing with dms
            # screenshot utility
            grim
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

          # FIXME: this is not only window manager config anymore. rather a DE? (maybe move to profiles/desktop?)
          # TODO: think about replacing each of these with DMS

          modules.home.rofi.enable = true;

          services.swayidle = {
            enable = true;
            timeouts = [
              {
                timeout = 1200;
                command = "${pkgs.systemd}/bin/systemctl suspend";
              }
            ];
          };

          services.gammastep = {
            enable = true;
            provider = "geoclue2";
          };
        };
      })
    ];
}
