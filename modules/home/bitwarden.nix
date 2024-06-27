{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.home.bitwarden;
in {
  options.modules.home.bitwarden = with lib; {
    enable = mkEnableOption "bitwarden menu";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi-rbw-wayland
    ];

    programs.rbw = {
      enable = true;
      settings = {
        base_url = "https://bitwarden.jakobkukla.xyz/";
        email = "jakob.kukla@gmail.com";
        # TODO: use pinentry-rofi once https://github.com/plattfot/pinentry-rofi/pull/24 is merged and https://github.com/plattfot/pinentry-rofi/issues/23 is resolved
        pinentry = pkgs.pinentry-qt;
      };
    };
  };
}
