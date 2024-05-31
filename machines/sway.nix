{pkgs, ...}: {
  # Sway config is managed by home-manager. This is needed for the DM and xdg-desktop-portal.
  programs.sway.enable = true;

  services.displayManager = {
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

  # Enable real-time capabilities for all programs run by the users group (in particular sway)
  security.pam.loginLimits = [
    {
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = 1;
    }
  ];

  # Enable polkit authentication agent
  environment.systemPackages = with pkgs; [
    polkit_gnome
  ];
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
