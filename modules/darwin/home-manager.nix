{config, ...}: {
  config = {
    home-manager.users.${config.modules.user.name} = {
      # Copy apps instead of linking them so Spotlight indexes them (default as
      # of home.stateVersion >= 25.11)
      targets.darwin = {
        linkApps.enable = false;
        copyApps.enable = true;
      };
    };
  };
}
