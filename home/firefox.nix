{ ... }:

{
  home-manager.users.jakob.programs.firefox = {
    enable = true;

    profiles.main.settings = {
      # This fixes the go-back-on-right-click bug
      "ui.context_menus.after_mouseup" = true;

      # Disable ads on start page
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

      # Disable firefox view
      "browser.tabs.firefox-view" = false;

      # Enable vaapi video acceleration
      "media.ffmpeg.vaapi.enabled" = true;
    };
  };
}
