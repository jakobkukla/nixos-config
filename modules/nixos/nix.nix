{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.nix;
in {
  options.modules.nix = with lib; {
    enable = mkEnableOption "Nix and NixOS configuration";
    enableNixOS =
      mkEnableOption "NixOS configuration"
      // {
        default = true;
      };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      nix = {
        package = pkgs.lixPackageSets.git.lix;

        # Disable legacy nix channels
        channel.enable = false;

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 5d";
        };

        settings = {
          experimental-features = [
            # Enable flakes
            "nix-command"
            "flakes"

            # Enable flake self attribute (Lix)
            "flake-self-attrs"
          ];

          # Disable the global registry
          flake-registry = "";

          substituters = [
            "https://cache.nixos.org?priority=40"
            "https://nix-community.cachix.org?priority=41"
            "https://numtide.cachix.org?priority=43"
            "https://jakobkukla.cachix.org?priority=44"
            "https://attic.jakobkukla.xyz/system?priority=45"
          ];
          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
            "jakobkukla.cachix.org-1:Wk6Y2/s1YlTwsZKCs46v9uYejYUnVdzXTXzbJbYv+1s="
            "system:nVcKbJl9QpDnXrVPUGItRzmFvyHYf+64JBSaKkKoZGc="
          ];

          # Netrc file for private cache authentication
          netrc-file = config.age.secrets.netrc-attic.path;
        };
      };

      home-manager.users.${config.modules.user.name} = {
        # FIXME: home-manager profiles don't get gc'ed otherwise due to https://github.com/NixOS/nix/issues/8508
        nix.gc = {
          automatic = true;
          options = "--delete-older-than 5d";
        };

        # TODO: think about replacing nix.gc with nh's clean service
        programs.nh.enable = true;
      };
    }

    (lib.mkIf cfg.enableNixOS {
      # Auto-update NixOS
      # system.autoUpgrade.enable = true;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "22.05"; # Did you read the comment?
    })
  ]);
}
