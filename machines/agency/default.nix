{
  config,
  inputs,
  ...
}: {
  flake.darwinConfigurations = {
    agency = inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs;};
      modules = [
        config.flake.darwinModules.default
        ./configuration.nix
      ];
    };
  };
}
