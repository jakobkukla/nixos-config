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

  outputs = inputs: {
    nixosConfigurations = {
      matebook = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
          ./machines/matebook/configuration.nix
          inputs.impermanence.nixosModules.impermanence
          (import ./machines/impermanence.nix)
          inputs.home-manager.nixosModules.home-manager
          (import ./home/matebook.nix)
          inputs.agenix.nixosModules.default
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    };

    devShells.x86_64-linux.default = let
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
      };
    in
      inputs.devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          {
            packages = with pkgs; [
              alejandra
            ];

            pre-commit.hooks = {
              alejandra.enable = true;
              markdownlint.enable = true;
            };
          }
        ];
      };
  };
}
