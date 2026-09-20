{
  lib,
  pkgs,
  config,
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
      passwordManager = mkOption {
        type = types.str;
        default = lib.getExe pkgs.rofi-rbw-wayland;
      };
      volumeUp = mkOption {
        type = types.str;
        default = "wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+";
      };
      volumeDown = mkOption {
        type = types.str;
        default = "wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-";
      };
      volumeMute = mkOption {
        type = types.str;
        default = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
      micMute = mkOption {
        type = types.str;
        default = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      };
      brightnessUp = mkOption {
        type = types.str;
        default = "brightnessctl set +10%";
      };
      brightnessDown = mkOption {
        type = types.str;
        default = "brightnessctl set 10%-";
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
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1"; # Fix java non-parenting issues
    };

    # fix xdg-open in FHS or wrappers (see https://github.com/NixOS/nixpkgs/issues/160923)
    xdg.portal.xdgOpenUsePortal = true;

    # location (needed for gammastep)
    location.provider = "geoclue2";

    # Enable polkit authentication agent
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    home-manager.users.${config.modules.user.name} = {
      home.packages = with pkgs; [
        wl-clipboard
        # screenshot utilities
        grim
        slurp
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

      modules.home.rofi.enable = true;

      services.dunst.enable = true;

      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = 1200;
            command = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
      };

      services.gammastep = {
        enable = true;
        provider = "geoclue2";
      };
    };
  };
}
