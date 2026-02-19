{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations = {
    triton = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        inputs.nixos-hardware.nixosModules.common-cpu-intel

        config.flake.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
