{pkgs, ...}: {
  # Sway config is managed by home-manager. This is needed for the DM and xdg-desktop-portal.
  programs.sway.enable = true;

  services.xserver.displayManager = {
    defaultSession = "sway";
    autoLogin = {
      enable = true;
      user = "jakob";
    };
  };

  # Enable xdg-desktop-portal
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # fix xdg-open in FHS or wrappers (see https://github.com/NixOS/nixpkgs/issues/160923)
    xdgOpenUsePortal = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
