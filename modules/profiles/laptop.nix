{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.profiles.laptop;
in {
  options.profiles.laptop = with lib; {
    enable = mkEnableOption "laptop profile";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.modules.user.name} = {
      services.batsignal.enable = true;
    };
  };
}
