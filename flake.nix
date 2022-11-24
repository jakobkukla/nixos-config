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
    nixosConfigurations =
    let
      commonModules = [
        impermanence.nixosModules.impermanence (import ./machines/impermanence.nix)
        agenix.nixosModules.age
      ];
      
      system = "x86_64-linux";

      specialArgs = {
        inherit agenix vscode-server;
      };
    in
    {
      matebook = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;

        modules = commonModules ++ [
          ./machines/matebook/configuration.nix
          home-manager.nixosModules.home-manager (import ./home/machines/matebook.nix)
        ];
      };
      pc = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;

        modules = commonModules ++ [
          ./machines/pc/configuration.nix
          home-manager.nixosModules.home-manager (import ./home/machines/pc.nix)
        ];
      };
    };
  };
}
