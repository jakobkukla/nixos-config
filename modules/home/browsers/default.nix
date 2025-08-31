{
  lib,
  config,
  ...
}: let
  cfg = config.modules.home.browsers;
in {
  imports = [
    ./firefox-based.nix
  ];

  options.modules.home.browsers = with lib; {
    defaultBrowser = mkOption {
      type = types.nullOr (types.enum ["firefox" "zen-browser"]);
      default = null;
      description = ''
        Set the default web browser.
      '';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.defaultBrowser != null)
      {
        assertions = [
          {
            assertion = cfg.firefox-based.${cfg.defaultBrowser}.enable;
            message = "`${cfg.defaultBrowser}` is set as default browser but not enabled.";
          }
        ];

        modules.home.defaultApplications.defaultBrowser =
          {
            firefox = "firefox.desktop";
            zen-browser = "zen-beta.desktop";
          }.${
            cfg.defaultBrowser
          };
      })
  ];
}
