{
  description = "NixOS system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  };

  outputs = inputs@{ nixpkgs, home-manager, agenix, nix-doom-emacs, ... }: {
    nixosConfigurations = {
      matebook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/matebook/configuration.nix
          home-manager.nixosModules.home-manager (import ./home/matebook.nix)
          agenix.nixosModules.age
        ];
        specialArgs = {
          inherit agenix;
          inherit nix-doom-emacs;
        };
      };
    };
  };
}
