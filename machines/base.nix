# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # location (needed for gammastep)
  location.provider = "geoclue2";

  # FIXME: workaround for MLS shutdown. See: https://github.com/NixOS/nixpkgs/issues/321121
  services.geoclue2 = {
    geoProviderUrl = "https://beacondb.net/v1/geolocate";
    # submitData = true;
    # submissionUrl = "https://beacondb.net/v2/geosubmit";
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "de_AT.UTF-8";
  console.keyMap = "de";

  programs.gnupg.agent.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    python3

    libarchive
    wget
    htop

    man-pages
    man-pages-posix
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
}
