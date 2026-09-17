{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf (config.device.role == "workstation") {
    fonts.packages = with pkgs; [
      source-code-pro
      nerd-fonts.symbols-only
    ];

    home-manager.users.${config.modules.user.name} = {
      modules.home = {
        browsers = {
          defaultBrowser = "zen-browser";

          firefox-based = {
            firefox.enable = true;
            zen-browser.enable = true;
          };
        };

        alacritty.enable = true;
      };

      programs.sioyek.enable = true;
    };
  };
}
