{ pkgs, ... }:

{
  # Sway config is managed by home-manager. This is needed for the DM and xdg-desktop-portal.
  programs.sway.enable = true;
  services.xserver.displayManager.defaultSession = "sway";

  # Enable xdg-desktop-portal
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
