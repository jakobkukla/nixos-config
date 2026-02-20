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
    sharedPolicies = {
      # Disable default browser check
      DontCheckDefaultBrowser = true;

      # Disable Firefox telemetry
      DisableTelemetry = true;

      # Disable password saving prompt
      OfferToSaveLogins = false;
    };

    sharedSettings = lib.mkMerge [
      {
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
          policies = lib.recursiveUpdate sharedPolicies {
            # Disable ads on start page
            FirefoxHome = {
              SponsoredTopSites = false;
              SponsoredPocket = false;
            };

            # Disable pocket
            DisablePocket = true;
          };
          profiles.main.settings = sharedSettings;
        };
      })

      (lib.mkIf cfg.zen-browser.enable {
        programs.zen-browser = {
          enable = true;
          suppressXdgMigrationWarning = true;

          policies = sharedPolicies;
          profiles.main.settings = sharedSettings;
        };
      })
    ];
}
