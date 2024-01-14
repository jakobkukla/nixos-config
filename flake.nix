{
  description = "NixOS system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    impermanence.url = "github:nix-community/impermanence";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    vscode-server.url = "github:msteen/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv/latest";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    nixpkgs,
    nixos-hardware,
    impermanence,
    home-manager,
    agenix,
    vscode-server,
    devenv,
    ...
  }: {
    nixosConfigurations = {
      matebook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-gpu-nvidia-disable
          ./machines/matebook/configuration.nix
          impermanence.nixosModules.impermanence
          (import ./machines/impermanence.nix)
          home-manager.nixosModules.home-manager
          (import ./home/matebook.nix)
          agenix.nixosModules.default
        ];
        specialArgs = {
          inherit agenix vscode-server;
        };
      };
    };

    devShells.x86_64-linux.default = devenv.lib.mkShell {
      inherit inputs;
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      modules = [
        {
          pre-commit.hooks = {
            alejandra.enable = true;
            markdownlint.enable = true;
          };
        }
      ];
    };
  };
}
