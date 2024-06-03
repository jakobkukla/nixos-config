# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./fs.nix
  ];

  # TODO: put this somewhere else
  modules = {
    nix.enable = true;

    user = {
      enable = true;
      user = "jakob";
    };

    printer.enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Linux kernel configuration
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  networking.firewall.enable = false; # Necessary for accessing ports from another machine (eg Jellyfin developement)
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # location (needed for gammastep)
  location.provider = "geoclue2";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_AT.UTF-8";
  console.keyMap = "de";

  fonts.packages = with pkgs; [
    source-code-pro
    (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
  ];

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

  # Secrets
  age = {
    secrets.root.file = ../secrets/root.age;
    secrets.jakob.file = ../secrets/jakob.age;
    secrets.netrc-attic.file = ../secrets/netrc-attic.age;
    secrets.spotify = {
      file = ../secrets/spotify.age;
      owner = "jakob";
    };
  };

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    python3
    docker-compose

    inputs.agenix.packages.x86_64-linux.default

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
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
