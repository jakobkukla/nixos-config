{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf (config.device.role == "workstation") {
    modules.hyprland.enable = true;

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

    # location (needed for gammastep)
    location.provider = "geoclue2";

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

      services.dunst.enable = true;
    };
  };
}
