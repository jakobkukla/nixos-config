{
  lib,
  config,
  ...
}: let
  cfg = config.modules.hyprland;
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.modules.user.name} = {
      wayland.windowManager.hyprland.settings = {
        # monitors
        monitor = cfg.monitors;

        # tearing
        general.allow_tearing = lib.mkIf cfg.enableTearing "true";
        windowrulev2 = lib.mkIf cfg.enableTearing "immediate, class:^(cs2)$";

        misc.disable_hyprland_logo = "true";

        input = {
          kb_layout = "de";
          kb_variant = "nodeadkeys";

          natural_scroll =
            if cfg.enableNaturalScroll
            then "true"
            else "false";
          sensitivity = "0.1";

          touchpad = {
            # doesn't work for some reason
            tap-to-click = "false";
            clickfinger_behavior = "true";
            disable_while_typing = "true";
          };
        };

        animation = "global, 0,,";
      };
    };
  };
}
