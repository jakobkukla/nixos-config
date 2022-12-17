# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, agenix, ... }:

{
  # Auto-update NixOS
  # system.autoUpgrade.enable = true;

  # Auto garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 5d";
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use personal binary cache and nixos cache
  nix.settings = {
    substituters = [
      "https://jakobkukla.cachix.org/"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "jakobkukla.cachix.org-1:Wk6Y2/s1YlTwsZKCs46v9uYejYUnVdzXTXzbJbYv+1s="
    ];
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

  # Select internationalisation properties.
  i18n.defaultLocale = "de_AT.UTF-8";
  console.keyMap = "de";

  # Overlays
  nixpkgs.overlays = import ../pkgs;

  nixpkgs.config.allowUnfree = true;
 
  fonts.fonts = with pkgs; [
    source-code-pro
    font-awesome
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
    secrets.spotify = {
      file = ../secrets/spotify.age;
      owner = "jakob";
    };
    identityPaths = [ "/home/jakob/.ssh/id_ed25519" ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable SANE for scanner support.
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };

  # Needed for scanner network discovery
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.jakob = {
    isNormalUser = true;
    home = "/home/jakob";
    extraGroups = [ "wheel" "networkmanager" "video" "docker" "scanner" "lp" ]; # Enable ‘sudo’ for the user.
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    python3
    docker-compose

    agenix.defaultPackage.x86_64-linux

    libarchive
    wget
    htop
    pavucontrol
    pulseaudio # Only needed for pactl
    zsh-history-substring-search

    gcc
    gnumake
    rustup
    ocaml
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
  services.openssh.passwordAuthentication = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

