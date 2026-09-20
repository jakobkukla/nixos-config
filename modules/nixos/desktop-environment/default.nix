{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.desktopEnvironment;
in {
  imports = [
    ./compositors/hyprland
    ./compositors/sway.nix
  ];

  options.modules.desktopEnvironment = with lib; {
    enable = mkEnableOption "Wayland desktop environment";

    greeterCompositor = mkOption {
      type = types.enum ["hyprland" "sway"];
      example = "hyprland";
      description = ''
        The compositor the greeter runs in.
      '';
    };

    input.naturalScroll = mkEnableOption "natural scrolling";

    commands = {
      terminal = mkOption {
        type = types.str;
        default = lib.getExe pkgs.alacritty;
      };
      launcher = mkOption {
        type = types.str;
        default = "${lib.getExe pkgs.rofi} -m 1 -show drun";
      };
      spotlight = mkOption {
        type = types.str;
        default = "dms ipc spotlight toggle";
      };
      passwordManager = mkOption {
        type = types.str;
        default = lib.getExe pkgs.rofi-rbw-wayland;
      };
      notifications = mkOption {
        type = types.str;
        default = "dms ipc notifications toggle";
      };
      settings = mkOption {
        type = types.str;
        default = "dms ipc settings toggle";
      };
      notepad = mkOption {
        type = types.str;
        default = "dms ipc notepad toggle";
      };
      lock = mkOption {
        type = types.str;
        default = "dms ipc lock lock";
      };
      powerMenu = mkOption {
        type = types.str;
        default = "dms ipc powermenu toggle";
      };
      clipboard = mkOption {
        type = types.str;
        default = "dms ipc clipboard toggle";
      };
      nightMode = mkOption {
        type = types.str;
        default = "dms ipc night toggle";
      };
      screenshot = mkOption {
        type = types.str;
        default = "dms screenshot region";
      };
      screenshotFull = mkOption {
        type = types.str;
        default = "dms screenshot full";
      };
      volumeUp = mkOption {
        type = types.str;
        default = "dms ipc audio increment 3";
      };
      volumeDown = mkOption {
        type = types.str;
        default = "dms ipc audio decrement 3";
      };
      volumeMute = mkOption {
        type = types.str;
        default = "dms ipc audio mute";
      };
      micMute = mkOption {
        type = types.str;
        default = "dms ipc audio micmute";
      };
      brightnessUp = mkOption {
        type = types.str;
        default = "dms ipc brightness increment 5 ''";
      };
      brightnessDown = mkOption {
        type = types.str;
        default = "dms ipc brightness decrement 5 ''";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.compositors.${cfg.greeterCompositor}.enable;
        message = "`${cfg.greeterCompositor}` is configured as the greeter compositor but is not enabled";
      }
    ];

    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = cfg.greeterCompositor;
      configHome = config.modules.user.homeDirectory;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1"; # Fix java non-parenting issues
    };

    # fix xdg-open in FHS or wrappers (see https://github.com/NixOS/nixpkgs/issues/160923)
    xdg.portal.xdgOpenUsePortal = true;

    # location (needed for DMS weather and night mode)
    location.provider = "geoclue2";

    home-manager.users.${config.modules.user.name} = {
      imports = [
        inputs.dms.homeModules.dank-material-shell
      ];

      programs.dank-material-shell = {
        enable = true;
        systemd.enable = true;

        settings = {
          # Theme
          currentThemeName = "dynamic";
          matugenScheme = "scheme-tonal-spot";

          # Power management
          lockBeforeSuspend = true;
          acSuspendTimeout = 1200;
          batterySuspendTimeout = 1200;

          # Auto-location for weather and night mode
          useAutoLocation = true;
        };
      };

      home.packages = with pkgs; [
        wl-clipboard
      ];

      home.pointerCursor = {
        enable = true;
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 24;

        gtk.enable = true;
        x11.enable = true;
      };

      gtk.enable = true;

      programs.rofi.enable = true;
    };
  };
}
