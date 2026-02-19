{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations = {
    inferno = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        inputs.nixos-hardware.nixosModules.raspberry-pi-4

        config.flake.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
