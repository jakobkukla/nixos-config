{
  description = "NixOS system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    vscode-server.url = "github:msteen/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, impermanence, home-manager, agenix, vscode-server, ... }: {
    nixosConfigurations = {
      matebook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/matebook/configuration.nix
          impermanence.nixosModules.impermanence (import ./machines/impermanence.nix)
          home-manager.nixosModules.home-manager (import ./home/matebook.nix)
          agenix.nixosModules.default
        ];
        specialArgs = {
          inherit agenix vscode-server;
        };
      };
    };
  };
}
