{
  lib,
  config,
  osConfig,
  ...
}: let
  cfg = config.modules.home.senpai;
in {
  options.modules.home.senpai = with lib; {
    enable = mkEnableOption "senpai";
  };

  config = lib.mkIf cfg.enable {
    programs.senpai = {
      enable = true;

      config = {
        address = "irc.jakobkukla.xyz";
        nickname = "jakob";
        password-cmd = [
          "cat"
          osConfig.age.secrets.soju.path
        ];
      };
    };
  };
}
