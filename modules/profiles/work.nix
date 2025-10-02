{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.profiles.work;
in {
  options.profiles.work = with lib; {
    enable = mkEnableOption "work profile";
  };

  config = lib.mkIf cfg.enable (let
    moxzNXPBuilderIP = "10.8.2.54";
    moxzNXPBuilderDevDrive = "/home/moxz";
  in {
    virtualisation.podman = {
      enable = true;
    };

    networking.networkmanager.plugins = with pkgs; [
      networkmanager-openvpn
    ];

    environment.systemPackages = [
      # Install perf corresponding to kernel
      config.boot.kernelPackages.perf
    ];

    # Mount dev NFS drive
    fileSystems."${config.modules.user.homeDirectory}/Documents/yocto" = {
      device = "${moxzNXPBuilderIP}:${moxzNXPBuilderDevDrive}";
      fsType = "nfs";
    };

    # add udev rules to use uhd devices in distrobox
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

    home-manager.users.${config.modules.user.name} = {
      home.packages = with pkgs; [
        mattermost-desktop

        # Flash .bmap files (Yocto)
        bmap-tools
      ];

      programs.git = {
        userName = lib.mkForce "Jakob Kukla";
        userEmail = lib.mkForce "jakob@moxzcomm.com";
      };

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

      programs.distrobox = {
        enable = true;
        containers.ubuntu = {
          image = "ubuntu:22.04";

          # Packages:
          # locales ... see below
          # udev ... for radio libuhd support
          # clangd ... for helix lsp
          # python3-requests ... for uhd_images_downloader
          additional_packages = "locales udev clangd python3-requests";
          init_hooks = [
            # Configure system locales needed for tab completion
            # See https://github.com/starship/starship/issues/2176
            "locale-gen ${config.i18n.defaultLocale}"
            "update-locale"
          ];
        };
      };
    };
  });
}
