{
  lib,
  config,
  ...
}: let
  cfg = config.device;
in {
  options.device = with lib; {
    role = mkOption {
      type = types.enum ["workstation" "server" "appliance"];
      description = ''
        The purpose of this machine.
      '';
    };

    headless = mkOption {
      type = types.bool;
      readOnly = true;
      default = builtins.elem cfg.role ["server" "appliance"];
      description = ''
        Whether this machine runs without a display and user session.
      '';
    };

    virtual = mkEnableOption "virtual machine";

    hardware = {
      battery = mkEnableOption "battery";
      bluetooth = mkEnableOption "bluetooth";
      internalDisplay = mkEnableOption "internal display";
      touchpad = mkEnableOption "touchpad";
      wifi = mkEnableOption "wifi";
    };
  };
}
