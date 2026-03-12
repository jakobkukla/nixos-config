{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.windowManager.niri;
in {
  imports = [
    inputs.niri.nixosModules.niri

    ./binds.nix
    ./settings.nix
  ];

  options.modules.windowManager.niri = with lib; {
    enable = mkEnableOption "niri window manager";
  };

  config = lib.mkIf cfg.enable {
    modules.windowManager.enable = true;

    niri-flake.cache.enable = false;

    # TODO: remove once https://github.com/NixOS/nixpkgs/pull/442948 is merged
    environment.systemPackages = [pkgs.xwayland-satellite];

    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };

    # Disable niri's polkit agent to use the DMS one.
    systemd.user.services.niri-flake-polkit.enable = false;

    home-manager.users.${config.modules.user.name} = {
      programs.dank-material-shell.niri = {
        enableKeybinds = true;
        enableSpawn = true;
        # FIXME: ideally I would prefer this instead of enableKeybinds but colors.kdl is missing?
        includes.enable = false;
      };
    };
  };
}
