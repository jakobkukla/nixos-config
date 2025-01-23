{...}: {
  imports = [
    ./hardware-configuration.nix
    ../base.nix
  ];

  profiles = {
    core.enable = true;
    chat.enable = false;
    desktop.enable = false;
    laptop.enable = false;
    media.enable = false;
    gaming.enable = false;
    work.enable = false;
    hifiberry.enable = true;
  };

  modules = {
    user = {
      enable = true;
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

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "nixos-hifiberry";

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # FIXME: open librespot and shairport-sync ports in firewall instead
  networking.firewall.enable = false;
}
