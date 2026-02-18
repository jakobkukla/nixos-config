{
  config,
  latestZfsCompatibleKernel,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../base.nix
  ];

  profiles = {
    core.enable = true;
    chat.enable = true;
    desktop.enable = true;
    laptop.enable = false;
    media.enable = true;
    gaming.enable = true;
    work.enable = false;
  };

  modules = {
    filesystem = {
      enable = true;
      fsType = "zfs";
      enableImpermanence = true;
    };

    hyprland = {
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

      wallpapers = [
        "DP-1,${config.modules.user.homeDirectory}/Pictures/wallpaper0.jpg"
        "DP-2,${config.modules.user.homeDirectory}/Pictures/wallpaper1.jpg"
      ];
    };

    games.servers.satisfactory.enable = true;
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

  # Linux kernel configuration
  boot.kernelPackages = latestZfsCompatibleKernel;

  networking.hostName = "mirage";
  networking.hostId = "4090d928";

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  networking.firewall.enable = false; # Necessary for accessing ports from another machine (eg Jellyfin developement)

  # Enable docker
  virtualisation.docker.enable = true;
}
