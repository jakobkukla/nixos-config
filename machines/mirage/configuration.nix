{config, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  device = {
    role = "workstation";
    hardware.wifi = true;
  };

  modules = {
    filesystem = {
      enable = true;
      fsType = "zfs";
      enableImpermanence = true;
    };

    desktopEnvironment.compositors.hyprland = {
      monitors = {
        "DP-1" = {
          resolution = "2560x1440@144";
          position = "0x0";
          scale = "1";
        };
        "DP-2" = {
          resolution = "3840x2160@60";
          position = "2560x0";
          scale = "1.5";
        };
      };
    };

    gaming = {
      enable = true;
      servers.satisfactory.enable = true;
    };
  };

  home-manager.users.${config.modules.user.name} = {
    modules.home = {
      chat.enable = true;
      media.enable = true;
    };
  };

  fileSystems."/mnt/d" = {
    device = "/dev/disk/by-uuid/f7e4a9c9-0e0f-4bae-8540-ca874a05a797";
    fsType = "btrfs";
    options = ["compress=zstd" "noatime"];
  };

  # aarch64 cross-compilation
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "mirage";
  networking.hostId = "4090d928";

  networking.firewall.enable = false; # Necessary for accessing ports from another machine (eg Jellyfin developement)

  # Enable docker
  virtualisation.docker.enable = true;
}
