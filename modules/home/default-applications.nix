{
  lib,
  config,
  ...
}: let
  cfg = config.modules.home.defaultApplications;
in {
  options.modules.home.defaultApplications = with lib; {
    enable = mkEnableOption "default application management";
    defaultBrowser = mkOption {
      type = types.str;
      example = literalExpression "firefox.desktop";
      description = ''
        Set the default browser application desktop file.
      '';
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf (cfg.defaultBrowser != null) {
      # set default browser
      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/http" = "${cfg.defaultBrowser}";
        "x-scheme-handler/https" = "${cfg.defaultBrowser}";
        "x-scheme-handler/ftp" = "${cfg.defaultBrowser}";
        "x-scheme-handler/chrome" = "${cfg.defaultBrowser}";
        "text/html" = "${cfg.defaultBrowser}";
        "text/xml" = "${cfg.defaultBrowser}";
        "application/x-extension-htm" = "${cfg.defaultBrowser}";
        "application/x-extension-html" = "${cfg.defaultBrowser}";
        "application/x-extension-shtml" = "${cfg.defaultBrowser}";
        "application/xhtml+xml" = "${cfg.defaultBrowser}";
        "application/x-extension-xhtml" = "${cfg.defaultBrowser}";
        "application/x-extension-xht" = "${cfg.defaultBrowser}";
      };
    })
  ]);
}
