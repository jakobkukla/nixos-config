{
  inputs,
  modulesPath,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    (modulesPath + "/profiles/qemu-guest.nix")

    ./disk-config.nix
    ./networking.nix
    ../base.nix
  ];

  profiles = {
    bare-metal.enable = false;
    core.enable = true;
    chat.enable = false;
    desktop.enable = false;
    server.enable = true;
    laptop.enable = false;
    media.enable = false;
    work.enable = false;
  };

  modules = {
    user = {
      enable = true;
      name = "vps";
      enableXdgUser = false;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  # Use grub as boot loader as it also has BIOS support.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  machines.vertigo.networking = {
    ipv4 = {
      address = "138.201.189.162";
      prefixLength = 32;
    };
    ipv6 = {
      address = "2a01:4f8:c013:b50a::1";
      prefixLength = 64;
    };
  };
}
