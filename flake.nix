{
  description = "NixOS system config";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    impermanence.url = "github:nix-community/impermanence";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    vscode-server.url = "github:msteen/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";

    flake-modules.url = "github:jakobkukla/flake-modules";
    flake-modules.inputs.flake-parts.follows = "flake-parts";
    flake-modules.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks-nix.follows = "flake-modules/git-hooks-nix";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.flake-modules.modules.flake.devshell
        inputs.flake-modules.modules.flake.formatter

        ./machines
        ./modules
      ];

      systems = ["x86_64-linux" "aarch64-linux"];
    };
}
