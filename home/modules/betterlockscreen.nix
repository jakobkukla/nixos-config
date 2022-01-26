{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.betterlockscreen;

in {
  meta.maintainers = with maintainers; [ sebtm ];

  options = {
    services.betterlockscreen = {
      enable = mkEnableOption "betterlockscreen, a screen-locker module";

      package = mkOption {
        type = types.package;
        default = pkgs.betterlockscreen;
        defaultText = literalExpression "pkgs.betterlockscreen";
        description = "Package providing <command>betterlockscreen</command>.";
      };

      extraConfig = mkOption {
        type = types.lines;
        description = "Additional configuration to add.";
        default = "";
        example = ''
          display_on=0
          span_image=false
          lock_timeout=300
          fx_list=(dim blur dimblur pixel dimpixel color)
          dim_level=40
        '';
      };

      arguments = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description =
          "List of arguments appended to <literal>./betterlockscreen --lock [args]</literal>";
      };

      inactiveInterval = mkOption {
        type = types.int;
        default = 10;
        description = ''
          Value used for <option>services.screen-locker.inactiveInterval</option>.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "services.betterlockscreen" pkgs
        lib.platforms.linux)
    ];

    home.packages = [ cfg.package ];
    xdg.configFile."betterlockscreenrc".source = ''${cfg.extraConfig}'';

    services.screen-locker = {
      enable = true;
      inactiveInterval = cfg.inactiveInterval;
      lockCmd = "${cfg.package}/bin/betterlockscreen --lock ${
          concatStringsSep " " cfg.arguments
        }";
    };
  };
}

