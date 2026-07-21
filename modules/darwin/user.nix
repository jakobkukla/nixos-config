{
  lib,
  config,
  ...
}: let
  cfg = config.modules.user;
in {
  config = lib.mkIf cfg.enable {
    users.users.${cfg.name}.home = cfg.homeDirectory;
  };
}
