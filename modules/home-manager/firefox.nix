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
        }

        (lib.mkIf cfg.enableSelfHostedSync {
          # Use self hosted sync server
          "identity.sync.tokenserver.uri" = "https://firefox-sync.jakobkukla.xyz/1.0/sync/1.5";
        })
      ];
    };
  };
}
