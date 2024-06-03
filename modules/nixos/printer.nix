{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.printer;
in {
  options.modules.printer = with lib; {
    enable = mkEnableOption "printing and scanning support";
  };

  config = lib.mkIf cfg.enable {
    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable SANE for scanner support.
    hardware.sane = {
      enable = true;
      extraBackends = [pkgs.sane-airscan];
    };

    # Needed for scanner network discovery
    services.avahi = {
      enable = true;
      nssmdns4 = true;
    };
  };
}
