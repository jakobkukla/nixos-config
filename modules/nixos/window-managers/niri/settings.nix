{
  lib,
  config,
  ...
}: let
  cfg = config.modules.windowManager.niri;
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.modules.user.name} = {
      programs.niri.settings = {
        prefer-no-csd = true;

        # TODO: should I configure these compositor-agnostic with `services.libinput` instead?
        input = {
          focus-follows-mouse.enable = true;

          keyboard.xkb = {
            layout = "de,us";
            variant = "nodeadkeys,";
            options = "grp:ctrls_toggle";
          };

          # TODO: mouse

          touchpad = {
            # TODO: should this be global (eg. for mouse and trackpad?)
            # Sensitivity
            accel-speed = 0.1;
            # Disable tap-to-click
            tap = false;
            # Disable natural scrolling for touchpads
            natural-scroll = false;
            # Enable two-finger right-click
            click-method = "clickfinger";
            # Disable while typing
            dwt = true;
          };
        };

        layout = {
          # By default split half/half
          default-column-width.proportion = 1. / 2.;

          # Column width presets
          preset-column-widths = [
            {proportion = 1. / 3.;}
            {proportion = 1. / 2.;}
            {proportion = 2. / 3.;}
          ];

          # Disable focus border
          focus-ring.enable = false;
        };

        # TODO: think about if i really want this
        window-rules = [
          {
            geometry-corner-radius = let
              r = 12.0;
            in {
              top-left = r;
              top-right = r;
              bottom-left = r;
              bottom-right = r;
            };
            clip-to-geometry = true;
          }
        ];

        # TODO: output (monitors)
      };
    };
  };
}
