{
  lib,
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
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 5d";
        };

        settings = {
          # Enable flakes
          experimental-features = ["nix-command" "flakes"];

          substituters = [
            "https://cache.nixos.org?priority=40"
            "https://nix-community.cachix.org?priority=41"
            "https://numtide.cachix.org?priority=42"
            "https://jakobkukla.cachix.org?priority=43"
            "https://attic.jakobkukla.xyz/system?priority=44"
          ];
          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
            "jakobkukla.cachix.org-1:Wk6Y2/s1YlTwsZKCs46v9uYejYUnVdzXTXzbJbYv+1s="
            "system:7gMaV5t8G5VkXhIOs8yV/divVtfZ90aXu4Wo0bYpIG8="
          ];

          # Netrc file for private cache authentication
          netrc-file = config.age.secrets.netrc-attic.path;
        };
      };

      # Overlays
      nixpkgs.overlays = import ../../pkgs;
      nixpkgs.config.allowUnfree = true;

      home-manager.users.${config.modules.user.name} = {
        # FIXME: can't I change this in nixos globally?
        nixpkgs.overlays = import ../../pkgs;
        nixpkgs.config.allowUnfree = true;
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
      system.stateVersion = "21.11"; # Did you read the comment?
    })
  ]);
}
