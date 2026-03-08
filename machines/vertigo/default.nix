{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations = {
    vertigo = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        config.flake.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
