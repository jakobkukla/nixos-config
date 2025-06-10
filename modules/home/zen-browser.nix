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
    setDefaultBrowser = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Set Zen as the default web browser.
      '';
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.zen-browser = {
        enable = true;

        profiles.main.settings = lib.mkMerge [
          {
            # This fixes the go-back-on-right-click bug
            "ui.context_menus.after_mouseup" = true;

            # Disable default browser check
            "browser.shell.checkDefaultBrowser" = false;

            # Set locale and search language
            "browser.search.region" = "AT";
            "general.useragent.locale" = "en-US";
            "distribution.searchplugins.defaultLocale" = "en-US";

            # Enable vaapi video acceleration
            "media.ffmpeg.vaapi.enabled" = true;

            # Decouple regional formats (dates, time, etc.) from display language
            "intl.regional_prefs.use_os_locales" = true;

            # Disable saving passwords
            "signon.rememberSignons" = false;
          }

          (lib.mkIf cfg.enableSelfHostedSync {
            # Use self hosted sync server
            "identity.sync.tokenserver.uri" = "https://firefox-sync.jakobkukla.xyz/1.0/sync/1.5";
          })
        ];
      };
    }

    (lib.mkIf cfg.setDefaultBrowser {
      modules.home.defaultApplications.defaultBrowser = "zen-beta.desktop";
    })
  ]);
}
