{ pkgs, ... }:

{
  home-manager.users.jakob = {
    home.packages = with pkgs; [
      batsignal
    ];

    systemd.user.services = {
      batsignal = {
        Unit = {
          Description = "Battery monitor daemon";
          Documentation = [ "man:batsignal(1)" ];
        };

        Service = {
          Type= "simple";
          ExecStart = "${pkgs.batsignal}/bin/batsignal";
          Restart = "on-failure";
          RestartSec = "1";
        };

        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
  };
}

