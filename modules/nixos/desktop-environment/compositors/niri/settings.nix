{
  lib,
  config,
  ...
}: let
  cfg = config.modules.desktopEnvironment.compositors.niri;
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.modules.user.name} = {
      wayland.windowManager.niri.settings = {
        prefer-no-csd = {};

        input = {
          focus-follows-mouse = {};

          keyboard.xkb = {
            layout = "de,us";
            variant = "nodeadkeys,";
            options = "grp:ctrls_toggle";
          };

          touchpad = {
            # Sensitivity
            accel-speed = 0.1;
            # Enable two-finger right-click
            click-method = "clickfinger";
            # Disable while typing
            dwt = {};
            natural-scroll = lib.mkIf config.modules.desktopEnvironment.input.naturalScroll {};
          };
        };

        layout = {
          # By default split half/half
          default-column-width.proportion = 1.0 / 2.0;

          # Column width presets
          preset-column-widths._children = [
            {proportion = 1.0 / 3.0;}
            {proportion = 1.0 / 2.0;}
            {proportion = 2.0 / 3.0;}
          ];

          # Disable focus border
          focus-ring.off = {};
        };

        window-rule = {
          geometry-corner-radius = [12.0 12.0 12.0 12.0];
          clip-to-geometry = true;
        };
      };
    };
  };
}
