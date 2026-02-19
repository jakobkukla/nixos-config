{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations = {
    cache = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        config.flake.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
