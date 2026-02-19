{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations = {
    mirage = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        config.flake.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
