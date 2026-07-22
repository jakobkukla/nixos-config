{config, ...}: let
  cfg = config.modules.user;
in {
  config = {
    users.users.${cfg.name}.home = cfg.homeDirectory;
  };
}
