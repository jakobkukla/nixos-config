{
  lib,
  config,
  ...
}: let
  cfg = config.modules.desktopEnvironment.compositors.niri;
in {
  imports = [
    ./binds.nix
    ./settings.nix
  ];

  options.modules.desktopEnvironment.compositors.niri = with lib; {
    enable = mkEnableOption "niri compositor";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.modules.desktopEnvironment.enable;
        message = "`modules.desktopEnvironment` must be enabled to use the niri compositor";
      }
    ];

    programs.niri = {
      enable = true;
      # Use the gtk file chooser.
      useNautilus = false;
    };

    home-manager.users.${config.modules.user.name} = {
      wayland.windowManager.niri.enable = true;
    };
  };
}
