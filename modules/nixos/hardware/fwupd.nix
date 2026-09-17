{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (!config.device.virtual) {
    services.fwupd.enable = true;
  };
}
