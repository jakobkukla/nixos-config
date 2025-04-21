{
  lib,
  config,
  ...
}: let
  cfg = config.modules.home.zen-browser;
in {
  options.modules.home.zen-browser = with lib; {
    enable = mkEnableOption "Zen web browser";
    enableSelfHostedSync =
      mkEnableOption "self hosted sync server"
      // {
        default = true;
      };
  };

  config = lib.mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;

      profiles.main.settings = lib.mkMerge [
        {
          # This fixes the go-back-on-right-click bug
          "ui.context_menus.after_mouseup" = true;

          # Enable vaapi video acceleration
          "media.ffmpeg.vaapi.enabled" = true;

          # Decouple regional formats (dates, time, etc.) from display language
          "intl.regional_prefs.use_os_locales" = true;
        }

        (lib.mkIf cfg.enableSelfHostedSync {
          # Use self hosted sync server
          "identity.sync.tokenserver.uri" = "https://firefox-sync.jakobkukla.xyz/1.0/sync/1.5";
        })
      ];
    };

    # Use zen-browser as standard browser
    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/ftp" = "zen-beta.desktop";
      "x-scheme-handler/chrome" = "zen-beta.desktop";
      "text/html" = "zen-beta.desktop";
      "text/xml" = "zen-beta.desktop";
      "application/x-extension-htm" = "zen-beta.desktop";
      "application/x-extension-html" = "zen-beta.desktop";
      "application/x-extension-shtml" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";
      "application/x-extension-xhtml" = "zen-beta.desktop";
      "application/x-extension-xht" = "zen-beta.desktop";
    };
  };
}
