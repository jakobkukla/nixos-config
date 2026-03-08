{
  lib,
  config,
  ...
}: let
  cfg = config.profiles.bare-metal;
in {
  options.profiles.bare-metal = with lib; {
    enable =
      mkEnableOption "bare-metal profile"
      // {
        default = true;
      };
  };

  config = lib.mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
