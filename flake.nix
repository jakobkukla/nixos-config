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

    # NOTE: This is a private repo. Keep using git+ssh to ensure it's using
    # ssh to fetch the repo and avoid access through GitHub Actions.
    # FIXME: update workflow fails as it cannot pin the input
    selfhosted.url = "git+ssh://git@github.com/jakobkukla/selfhosted";
    selfhosted.inputs.nixpkgs.follows = "nixpkgs";
    selfhosted.inputs.devenv.follows = "devenv";
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
          ]
          ++ (
            # NOTE: omit selfhosted module in CI as repo is private
            if builtins.getEnv "CI" != "true"
            then [
              inputs.selfhosted.nixosModules.default

              {
                selfhosted.enable = true;
                selfhosted.media.enable = true;
                selfhosted.appdataDir = "/var/lib/selfhosted";
                selfhosted.appdataLegacyDir = "/mnt/user/appdata";
                selfhosted.dataDir = "/mnt/user/data";
              }
            ]
            else []
          );
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
      triton = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
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
