{lib, ...}: {
  fileSystems."/" = {
    device = "rpool/nixos/root";
    fsType = "zfs";
    options = ["X-mount.mkdir"];
  };

  fileSystems."/home" = {
    device = "rpool/nixos/home";
    fsType = "zfs";
    options = ["X-mount.mkdir"];
    # Remove this after testing
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    device = "rpool/nixos/nix";
    fsType = "zfs";
    options = ["X-mount.mkdir"];
  };

  fileSystems."/persist" = {
    device = "rpool/nixos/persist";
    fsType = "zfs";
    options = ["X-mount.mkdir"];
    neededForBoot = true;
  };

  # /etc/ssh needs to be mounted in stage 1 for agenix to work
  fileSystems."/etc/ssh" = {
    depends = ["/persist"];
    neededForBoot = true;
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/nixos/root@blank
  '';
}
