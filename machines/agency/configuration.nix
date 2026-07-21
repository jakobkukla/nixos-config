{
  pkgs,
  config,
  ...
}: {
  # profiles = {
  #   chat.enable = true;
  #   desktop.enable = true;
  #   laptop.enable = true;
  #   media.enable = true;
  #   gaming.enable = true;
  #   development.enable = true;
  # };

  # FIXME: taken from profiles/desktop.nix
  fonts.packages = with pkgs; [
    source-code-pro
    nerd-fonts.symbols-only
  ];
  home-manager.users.${config.modules.user.name} = {
    # FIXME: workaround for broken spotlight indexing.
    # TODO: where to put this?
    targets.darwin = {
      linkApps.enable = false;
      copyApps.enable = true;
    };

    modules.home.alacritty.enable = true;
  };

  networking.hostName = "agency";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
