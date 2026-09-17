{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf config.device.hardware.internalDisplay {
    environment.systemPackages = with pkgs; [
      # Backlight brightness control
      brightnessctl
    ];
  };
}
