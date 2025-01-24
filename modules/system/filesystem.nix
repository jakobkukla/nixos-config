{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.filesystem;
in {
  options.modules.filesystem = with lib; {
    enable = mkEnableOption "filesystem module";
    enableImpermanence = mkEnableOption "ephemeral root";
    fsType = mkOption {
      type = types.enum ["btrfs" "zfs"];
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      # Define latestZfsCompatibleKernel argument
      # NOTE: Update this according to https://github.com/openzfs/zfs/releases
      _module.args.latestZfsCompatibleKernel = pkgs.linuxPackages_6_12;
    }

    (lib.mkIf (cfg.fsType == "btrfs") {
      fileSystems."/home" = {
        device = "/dev/mapper/enc";
        fsType = "btrfs";
        options = ["subvol=home" "compress=zstd" "noatime"];
      };

      fileSystems."/nix" = {
        device = "/dev/mapper/enc";
        fsType = "btrfs";
        options = ["subvol=nix" "compress=zstd" "noatime"];
      };
    })

    (lib.mkIf (cfg.fsType == "zfs") {
      boot.supportedFilesystems = ["zfs"];
      systemd.services.zfs-mount.enable = false;

      fileSystems."/" = {
        device = "rpool/nixos/root";
        fsType = "zfs";
      };

      fileSystems."/home" = {
        device = "rpool/nixos/home";
        fsType = "zfs";
      };

      fileSystems."/nix" = {
        device = "rpool/nixos/nix";
        fsType = "zfs";
        options = ["noatime"];
      };
    })

    (lib.mkIf (cfg.fsType == "zfs" && cfg.enableImpermanence) {
      fileSystems."/persist" = {
        device = "rpool/nixos/persist";
        fsType = "zfs";
        neededForBoot = true;
      };

      boot.initrd.postDeviceCommands = lib.mkAfter ''
        zfs rollback -r rpool/nixos/root@blank
      '';
    })

    (lib.mkIf (cfg.fsType == "btrfs" && !cfg.enableImpermanence) {
      # FIXME: untested!
      fileSystems."/" = {
        device = "/dev/mapper/enc";
        fsType = "btrfs";
        options = ["subvol=root" "compress=zstd" "noatime"];
      };
    })

    (lib.mkIf (cfg.fsType == "btrfs" && cfg.enableImpermanence) {
      fileSystems."/" = {
        device = "none";
        fsType = "tmpfs";
        options = ["size=3G" "mode=755"];
      };

      fileSystems."/persist" = {
        device = "/dev/mapper/enc";
        fsType = "btrfs";
        options = ["subvol=persist" "compress=zstd" "noatime"];
        neededForBoot = true;
      };
    })

    (lib.mkIf cfg.enableImpermanence {
      environment.persistence."/persist" = {
        hideMounts = true;

        files = [
          "/etc/machine-id"
        ];

        directories =
          [
            "/var/log"
            "/var/lib/bluetooth"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            # Save docker images and containers
            "/var/lib/docker"
            # Don't prompt sudo lecture on every reboot
            "/var/db/sudo/lectured"
            # Save NetworkManager connections
            "/etc/NetworkManager/system-connections"
            # Needed to keep 802.1X (eduroam) iwd provisioning files
            "/var/lib/iwd"
            # Save host ssh keys
            "/etc/ssh"
          ]
          ++ (lib.optionals config.modules.games.servers.satisfactory.enable [
            # Satisfactory server
            {
              directory = "/var/lib/satisfactory";
              user = "satisfactory";
              group = "satisfactory";
            }
          ]);
      };
    })
  ]);
}
