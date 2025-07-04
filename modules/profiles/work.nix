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
    moxzNXPBuilderDevDrive = "/home/moxz/yocto";
  in {
    virtualisation.podman = {
      enable = true;
    };

    environment.systemPackages = [
      # Install perf corresponding to kernel
      config.boot.kernelPackages.perf
    ];

    # Mount dev NFS drive
    fileSystems."${config.modules.user.homeDirectory}/Documents/yocto" = {
      device = "${moxzNXPBuilderIP}:${moxzNXPBuilderDevDrive}";
      fsType = "nfs";
    };

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
          additional_packages = "locales udev clangd";
          # Configure system locales needed for tab completion
          # See https://github.com/starship/starship/issues/2176
          init_hooks = [
            "locale-gen ${config.i18n.defaultLocale}"
            "update-locale"
          ];
        };
      };
    };
  });
}
