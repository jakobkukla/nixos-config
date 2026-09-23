{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations = {
    ancient = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        inputs.nixos-apple-silicon.nixosModules.default

        config.flake.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
