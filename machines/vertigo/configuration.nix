{
  inputs,
  modulesPath,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    (modulesPath + "/profiles/qemu-guest.nix")

    ./disk-config.nix
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

  networking.hostName = "vertigo";
  networking.firewall.enable = true;
}
