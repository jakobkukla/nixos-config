{...}: let
  deviceName = "HiFiBerry";
  alsaDeviceName = "default:CARD=sndrpihifiberry";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  profiles = {
    desktop.enable = false;
    laptop.enable = false;
    gaming.enable = false;
    work.enable = false;
  };

  modules = {
    user = {
      name = "pi";
      enableXdgUser = false;
    };
  };

  # Disable 3.5 jack audio device and disable power management for DAC
  boot.extraModprobeConfig = ''
    blacklist snd_bcm2835
    options snd_soc_core pmdown_time=-1
  '';

  # Enable HiFiBerry Dac+ overlay
  hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;
  hardware.deviceTree.enable = true;
  hardware.deviceTree.filter = "bcm2711-rpi-4*.dtb";
  hardware.hifiberry.dacplus.enable = true;

  # Spotify Connect
  modules.librespot = {
    enable = true;
    settings = {
      name = deviceName;
      bitrate = 320;
      enableVolumeNormalisation = true;
    };
  };

  # AirPlay
  services.shairport-sync = {
    enable = true;
    arguments = "-a ${deviceName} --output=alsa -- -d ${alsaDeviceName}";
  };

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "inferno";

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # FIXME: open librespot and shairport-sync ports in firewall instead
  networking.firewall.enable = false;
}
