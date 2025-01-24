{
  description = "NixOS system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
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
    nixosConfigurations = let
      defaultModules = [
        ./modules

        inputs.impermanence.nixosModules.impermanence
        inputs.home-manager.nixosModules.home-manager
        inputs.agenix.nixosModules.default
      ];
      specialArgs = {inherit inputs;};
    in {
      matebook = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules =
          defaultModules
          ++ [
            inputs.nixos-hardware.nixosModules.common-cpu-intel
            inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
            ./machines/matebook/configuration.nix
          ];
      };
      pc = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules =
          defaultModules
          ++ [
            ./machines/pc/configuration.nix
          ];
      };
      server = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules =
          defaultModules
          ++ [
            ./machines/server/configuration.nix
          ];
      };
      hifiberry = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "aarch64-linux";
        modules =
          defaultModules
          ++ [
            inputs.nixos-hardware.nixosModules.raspberry-pi-4
            ./machines/hifiberry/configuration.nix
          ];
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

            languages.nix.enable = true;

            pre-commit.hooks = {
              actionlint.enable = true;
              alejandra.enable = true;
              check-merge-conflicts.enable = true;
              commitizen.enable = true;
              deadnix.enable = true;
              markdownlint.enable = true;
            };
          }
        ];
      };
  };
}
