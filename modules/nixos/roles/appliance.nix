{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.device.role == "appliance") {
    networking.networkmanager.enable = true;
  };
}
