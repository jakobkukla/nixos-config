{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.profiles.gaming;
in {
  options.profiles.gaming = with lib; {
    enable = mkEnableOption "gaming profile";
  };

  config = lib.mkIf cfg.enable {
    # FIXME: gamemoderun renice is not working? test with gamemoded -t
    programs.gamemode.enable = true;
    users.users.${config.modules.user.name}.extraGroups = ["gamemode"];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      # Add proton-ge
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    programs.gamescope = {
      enable = true;
      # FIXME: enable once https://github.com/NixOS/nixpkgs/issues/292620 is fixed
      capSysNice = false;
    };

    modules.hyprland.enableTearing = true;

    home-manager.users.${config.modules.user.name} = {
      programs.mangohud.enable = true;
    };
  };
}
