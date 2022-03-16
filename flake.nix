{
  description = "NixOS system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, agenix, ... }: {
    nixosConfigurations = {
      matebook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/matebook/configuration.nix
          home-manager.nixosModules.home-manager (import ./home/matebook.nix)

          agenix.nixosModules.age
          # FIXME move this to machines/base.nix somehow
          {
            environment.systemPackages = [ agenix.defaultPackage.x86_64-linux ];
          }
        ];
      };
    };
  };
}
