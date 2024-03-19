{
  lib,
  config,
  pkgs,
  ...
}: let
  # FIXME: This is needed to source home.sessionVariables in Hyprland.
  # Keep track of https://github.com/nix-community/home-manager/issues/2659 for a cleaner solution.
  hyprlandWrapper = pkgs.writeShellScript "hyprland_wrapper" ''
    source "/home/jakob/.nix-profile/etc/profile.d/hm-session-vars.sh"

    exec ${lib.getExe config.programs.hyprland.package} $@
  '';
in {
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = hyprlandWrapper.outPath;
        user = "jakob";
      };
      default_session = initial_session;
    };
  };

  # unlock GPG keyring on login
  security.pam.services.greetd.enableGnomeKeyring = true;
}
