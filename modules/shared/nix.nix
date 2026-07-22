{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.nix;
in {
  options.modules.nix = with lib; {
    enable = mkEnableOption "Nix configuration";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      package = pkgs.lixPackageSets.git.lix;

      # Disable legacy nix channels
      channel.enable = false;

      gc = {
        automatic = true;
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

        extra-substituters = [
          "https://cache.nixos.org?priority=40"
          "https://nix-community.cachix.org?priority=41"
          "https://numtide.cachix.org?priority=43"
          "https://jakobkukla.cachix.org?priority=44"
          "https://attic.jakobkukla.xyz/system?priority=45"
        ];
        extra-trusted-public-keys = [
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
  };
}
