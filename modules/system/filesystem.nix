{
  lib,
  config,
  ...
}: let
  cfg = config.modules.filesystem;
in {
  options.modules.filesystem = with lib; {
    enable = mkEnableOption "filesystem module";
    enableImpermanence = mkEnableOption "ephemeral root";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
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
    }

    (lib.mkIf (!cfg.enableImpermanence) {
      # FIXME: untested!
      fileSystems."/" = {
        device = "/dev/mapper/enc";
        fsType = "btrfs";
        options = ["subvol=root" "compress=zstd" "noatime"];
      };
    })

    (lib.mkIf cfg.enableImpermanence {
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

      # /etc/ssh needs to be mounted in stage 1 for agenix to work
      fileSystems."/etc/ssh" = {
        depends = ["/persist"];
        neededForBoot = true;
      };

      environment.persistence."/persist" = {
        hideMounts = true;
        directories = [
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
        ];
        files = [
          "/etc/machine-id"
        ];
      };
    })
  ]);
}
