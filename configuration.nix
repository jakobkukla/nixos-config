# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./home/home.nix
    ];

  # Auto-update NixOS
  system.autoUpgrade.enable = true;
  # Auto garbage collection
  nix.gc.automatic = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # Linux kernel configuration
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "i915.enable_psr=0" ];

  networking.hostName = "nixos-matebook"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "de_AT.UTF-8";
  console.keyMap = "de";

  # Overlays
  nixpkgs.overlays = import ./pkgs;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "geogebra"
  ];

  fonts.fonts = with pkgs; [
    source-code-pro
    font-awesome
  ];

  # Power management
  services.tlp.enable = true;

  services.xserver = {
    enable = true;
    dpi = 192;
    layout = "de";

    libinput = {
      enable = true;
      touchpad = {
        accelSpeed = "0.4";
        tapping = false;
        clickMethod = "clickfinger";
        disableWhileTyping = true;
        naturalScrolling = true;
      };
    };

    desktopManager.xterm.enable = false;
    displayManager.defaultSession = "none+bspwm";
    displayManager.lightdm = {
      greeters.mini = {
        enable = true;
        user = "jakob";
        extraConfig = ''
          [greeter]
          user = jakob
          password-input-width = 15
          show-input-cursor = false
          [greeter-theme]
          font = "Source Code Pro"
          font-size = 30px
          background-image = ""
          background-color = "#0e0409"
          border-width = 5px
          border-color = "#edf0e1"
          text-color = "#0e0409"
          password-color = "#edf0e1"
          password-background-color = "#0e0409"
          password-border-radius = 0.341125em
          window-color = "#63956D"
          layout-space = 40
        '';
      };

      # This is needed for tiny and mini greeters
      extraSeatDefaults = "user-session = ${config.services.xserver.displayManager.defaultSession}";
    };
    windowManager.bspwm.enable = true;
  };

  services.greetd = {
    enable = false;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd /nix/store/cvnw5xmp30fs4g2mg3a9xqlwv2yijnxh-xsession-wrapper";
      };
    };
  };

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

  programs.light.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
    extraGroups = [ "wheel" "networkmanager" "video" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pywal             # Automatic themeing for bspwm

    wget
    htop
    git
    git-crypt
    pavucontrol
    neofetch
    pulseaudio # Only needed for pactl
    zsh-history-substring-search
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

