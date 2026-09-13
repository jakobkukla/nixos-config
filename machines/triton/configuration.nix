{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  profiles = {
    desktop.enable = true;
    laptop.enable = true;
  };

  modules = {
    filesystem = {
      enable = true;
      fsType = "zfs";
      enableImpermanence = true;
    };

    hyprland.monitors."eDP-1" = {
      resolution = "1920x1080";
      position = "0x0";
      scale = "1.25";
      disableOnLidSwitch = true;
    };

    vcs = {
      userName = "Jakob Kukla";
      userEmail = "jakob@moxzcomm.com";
    };
  };

  boot.loader.systemd-boot = {
    enable = true;
    # Add Ubuntu's grub boot loader.
    extraEntries."ubuntu.conf" = ''
      title Ubuntu
      efi /efi/ubuntu/shimx64.efi
    '';
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "moxz-triton";
  networking.hostId = "73e775f3";

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];

  # FIXME: investigate if this can be turned on
  networking.firewall.enable = false;

  # Thunderbolt userspace
  services.hardware.bolt.enable = true;

  # Enable podman
  virtualisation.podman.enable = true;

  # Mount dev NFS drive
  fileSystems."${config.modules.user.homeDirectory}/Documents/server" = {
    device = "10.8.2.54:/home/moxz";
    fsType = "nfs";
  };

  # add udev rules to use uhd devices without root
  services.udev.extraRules = ''
    #
    # Copyright 2011,2015 Ettus Research LLC
    # Copyright 2018 Ettus Research, a National Instruments Company
    #
    # SPDX-License-Identifier: GPL-3.0-or-later
    #

    #USRP1
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="fffe", ATTRS{idProduct}=="0002", MODE:="0666"

    #B100
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2500", ATTRS{idProduct}=="0002", MODE:="0666"

    #B200
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2500", ATTRS{idProduct}=="0020", MODE:="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2500", ATTRS{idProduct}=="0021", MODE:="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2500", ATTRS{idProduct}=="0022", MODE:="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3923", ATTRS{idProduct}=="7813", MODE:="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3923", ATTRS{idProduct}=="7814", MODE:="0666"
  '';

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  users.users.${config.modules.user.name}.extraGroups = ["wireshark"];

  environment.systemPackages = with pkgs; [
    perf
  ];

  home-manager.users.${config.modules.user.name} = {
    modules.home.vscode = {
      enable = true;
    };

    home.packages = with pkgs; [
      mattermost-desktop

      # Flash .bmap files (Yocto)
      bmaptool
    ];

    programs.nushell.enable = true;

    # TODO: install firefox plugin with nixos
    programs.keepassxc = {
      enable = true;
      settings = {
        Browser.Enabled = true;

        GUI = {
          ApplicationTheme = "dark";
          CompactMode = true;
          HidePasswords = true;
        };
      };
    };

    programs.claude-code.enable = true;
  };
}
