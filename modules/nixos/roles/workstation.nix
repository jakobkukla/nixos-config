{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf (config.device.role == "workstation") {
    modules.desktopEnvironment = {
      enable = true;
      defaultCompositor = "hyprland";
      compositors.hyprland.enable = true;
      input.naturalScroll = config.device.hardware.touchpad;
    };

    networking.networkmanager.enable = true;

    # Add eduroam configuration
    modules.eduroam.enable = config.device.hardware.wifi;

    # FIXME: Does this make sense here?
    modules.printer.enable = true;

    # Enable sound.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

    home-manager.users.${config.modules.user.name} = {
      home.packages = with pkgs; [
        pavucontrol
        scrcpy # TODO: remove this?
        xpra
      ];

      modules.home = {
        defaultApplications.enable = true;
        bitwarden.enable = true;
      };
    };
  };
}
