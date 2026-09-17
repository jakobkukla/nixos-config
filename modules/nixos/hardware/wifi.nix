{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.device.hardware.wifi {
    assertions = [
      {
        assertion = config.networking.networkmanager.enable;
        message = "wifi is managed by NetworkManager, which is not enabled";
      }
    ];

    networking.networkmanager.wifi.backend = "iwd";
  };
}
