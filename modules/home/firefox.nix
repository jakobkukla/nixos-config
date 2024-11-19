{
  lib,
  config,
  ...
}: let
  cfg = config.modules.home.firefox;
in {
  options.modules.home.firefox = with lib; {
    enable = mkEnableOption "Firefox web browser";
    enableSelfHostedSync =
      mkEnableOption "self hosted sync server"
      // {
        default = true;
      };
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      profiles.main.settings = lib.mkMerge [
        {
          # This fixes the go-back-on-right-click bug
          "ui.context_menus.after_mouseup" = true;

          # Disable ads on start page
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          # Disable pocket
          "extensions.pocket.enabled" = false;

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

    # Use firefox as standard browser
    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/ftp" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
      "text/html" = "firefox.desktop";
      "text/xml" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
    };
  };
}
