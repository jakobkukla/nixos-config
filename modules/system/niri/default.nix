{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.niri;
in {
  imports = [
    ./binds.nix
    ./settings.nix
  ];

  options.modules.niri = with lib; {
    enable = mkEnableOption "niri window manager";
  };

  config = lib.mkIf cfg.enable {
    niri-flake.cache.enable = false;

    # TODO: remove once https://github.com/NixOS/nixpkgs/pull/442948 is merged
    environment.systemPackages = [pkgs.xwayland-satellite];

    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };

    home-manager.users.${config.modules.user.name} = {
      programs.dankMaterialShell.niri = {
        enableKeybinds = true;
        enableSpawn = true;
      };
    };
  };
}
