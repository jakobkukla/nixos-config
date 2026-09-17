{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.device.hardware.battery {
    # Power management and performance scaling
    powerManagement.enable = true;
    services.auto-cpufreq.enable = true;
    services.thermald.enable = true;

    home-manager.users.${config.modules.user.name} = {
      # Battery notification daemon
      services.batsignal.enable = true;
    };
  };
}
