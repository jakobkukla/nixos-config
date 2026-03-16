{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.device.hardware.battery {
    # Power management and performance scaling
    powerManagement.enable = true;
    services.thermald.enable = true;
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;

    home-manager.users.${config.modules.user.name} = {
      # Battery notification daemon
      services.batsignal.enable = true;
    };
  };
}
