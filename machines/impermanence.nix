{
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
}
