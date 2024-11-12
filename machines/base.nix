# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
  # TODO: put this somewhere else
  modules = {
    nix.enable = true;
    user.enable = true;
  };

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

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      sudo = "sudo -E -s ";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.gnupg.agent.enable = true;

  # Enable Docker
  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    python3
    docker-compose

    libarchive
    wget
    htop
    pavucontrol
    zsh-history-substring-search

    gcc
    gnumake
    rustup
    gdb
    valgrind
    git
    man-pages
    man-pages-posix
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
