{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.device.hardware.bluetooth {
    hardware.bluetooth.enable = true;
  };
}
