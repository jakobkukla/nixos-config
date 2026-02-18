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

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";

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
      aztec = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          defaultModules
          ++ [
            inputs.nixos-hardware.nixosModules.common-cpu-intel
            inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
            ./machines/aztec/configuration.nix
          ];
      };
      cache = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          defaultModules
          ++ [
            ./machines/cache/configuration.nix
          ];
      };
      inferno = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          defaultModules
          ++ [
            inputs.nixos-hardware.nixosModules.raspberry-pi-4
            ./machines/inferno/configuration.nix
          ];
      };
      mirage = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          defaultModules
          ++ [
            ./machines/mirage/configuration.nix
          ];
      };
      triton = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          defaultModules
          ++ [
            inputs.nixos-hardware.nixosModules.common-cpu-intel
            ./machines/triton/configuration.nix
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

            git-hooks.hooks = {
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
