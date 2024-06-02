{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.home.batsignal;
in {
  options.modules.home.batsignal = with lib; {
    enable = mkEnableOption "batsignal battery monitor daemon";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      batsignal
    ];

    systemd.user.services = {
      batsignal = {
        Unit = {
          Description = "Battery monitor daemon";
          Documentation = ["man:batsignal(1)"];
        };

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.batsignal}/bin/batsignal";
          Restart = "on-failure";
          RestartSec = "1";
        };

        Install = {
          WantedBy = ["default.target"];
        };
      };
    };
  };
}
