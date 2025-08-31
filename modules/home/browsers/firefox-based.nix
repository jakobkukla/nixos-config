{
  lib,
  config,
  ...
}: let
  cfg = config.modules.home.browsers.firefox-based;
in {
  options.modules.home.browsers.firefox-based = with lib; {
    enableSelfHostedSync =
      mkEnableOption "self-hosted Firefox Sync server."
      // {
        default = true;
      };

    firefox = mkOption {
      description = "Firefox browser options.";
      default = {};
      example = {
        enable = true;
      };
      type = types.submodule {
        options = {
          enable = mkEnableOption "Firefox web browser.";
        };
      };
    };

    zen-browser = mkOption {
      description = "Zen browser options.";
      default = {};
      example = {
        enable = true;
      };
      type = types.submodule {
        options = {
          enable = mkEnableOption "Zen web browser.";
        };
      };
    };
  };

  config = let
    sharedSettings = lib.mkMerge [
      {
        # This fixes the go-back-on-right-click bug
        "ui.context_menus.after_mouseup" = true;

        # Disable default browser check
        "browser.shell.checkDefaultBrowser" = false;

        # Set locale and search language
        "browser.search.region" = "AT";
        "general.useragent.locale" = "en-US";
        "distribution.searchplugins.defaultLocale" = "en-US";

        # Decouple regional formats (dates, time, etc.) from display language
        "intl.regional_prefs.use_os_locales" = true;

        # Disable translation popup
        "browser.translations.automaticallyPopup" = false;

        # Enable vaapi video acceleration
        "media.ffmpeg.vaapi.enabled" = true;

        # Disable saving passwords
        "signon.rememberSignons" = false;
      }

      (lib.mkIf cfg.enableSelfHostedSync {
        # Use self hosted sync server
        "identity.sync.tokenserver.uri" = "https://firefox-sync.jakobkukla.xyz/1.0/sync/1.5";
      })
    ];
  in
    lib.mkMerge [
      (lib.mkIf cfg.firefox.enable {
        programs.firefox = {
          enable = true;
          profiles.main.settings = lib.recursiveUpdate sharedSettings {
            # Disable ads on start page
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

            # Disable pocket
            "extensions.pocket.enabled" = false;
          };
        };
      })

      (lib.mkIf cfg.zen-browser.enable {
        programs.zen-browser = {
          enable = true;
          profiles.main.settings = sharedSettings;
        };
      })
    ];
}
