{latestZfsCompatibleKernel, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../base.nix
  ];

  profiles = {
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
      name = "nas";
      enableXdgUser = false;
    };

    filesystem = {
      enable = true;
      fsType = "zfs";
      enableImpermanence = true;
    };
  };

  # FIXME: selfhosted: disable impermanence for /var/lib as it stores the appdata for some migrated services
  # TODO: migrate these services to /var/lib/selfhosted and remove this
  environment.persistence."/persist".directories = ["/var/lib"];

  # TODO: where to put this? change path to /mnt/data instead?
  # probably best if data is not a single dataset?
  fileSystems."/mnt/user/data" = {
    device = "tank/data";
    fsType = "zfs";
  };

  fileSystems."/var/lib/selfhosted" = {
    device = "rpool/appdata";
    fsType = "zfs";
  };

  fileSystems."/mnt/user/appdata" = {
    device = "rpool/appdata-legacy";
    fsType = "zfs";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false; # Firmware issue on this mainboard. See https://github.com/NixOS/nixpkgs/issues/75457

  # Linux kernel configuration
  boot.kernelPackages = latestZfsCompatibleKernel;

  networking.hostName = "nixos-server";
  networking.hostId = "1266a027";

  # NOTE: Docker is overwriting these. See https://github.com/NixOS/nixpkgs/issues/111852
  networking.firewall = {
    # FIXME: 'true' breaks connection to other host ports inside docker
    enable = false;
    allowedTCPPorts = [80 443];
  };

  # NOTE: Currently this needs to be turned off for initrd ssh.
  # probably desired for a server anyways. Otherwise try this https://github.com/NixOS/nixpkgs/issues/63941#issuecomment-2081126437
  networking.networkmanager.enable = false;

  # Enable docker
  virtualisation.docker.enable = true;

  # Stage 1 sshd to unlock zfs pools
  boot.kernelParams = ["ip=dhcp"];
  boot = {
    initrd.kernelModules = ["igb"];
    initrd.network = {
      # This will use udhcp to get an ip address.
      # Make sure you have added the kernel module for your network driver to `boot.initrd.availableKernelModules`,
      # so your initrd can load it!
      # Static ip addresses might be configured using the ip argument in kernel command line:
      # https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt
      enable = true;
      # NOTE: by default ssh authorizedKeys will be the same as for the root user
      ssh = {
        enable = true;
        # To prevent ssh clients from freaking out because a different host key is used,
        # a different port for ssh is useful (assuming the same host has also a regular sshd running)
        port = 2222;
        # hostKeys paths must be unquoted strings, otherwise you'll run into issues with boot.initrd.secrets
        # the keys are copied to initrd from the path specified; multiple keys can be set
        # you can generate any number of host keys using
        # `ssh-keygen -t ed25519 -N "" -f /path/to/ssh_host_ed25519_key`
        hostKeys = [/persist/etc/secrets/initrd/ssh_host_ed25519_key];
      };
    };
  };
}
