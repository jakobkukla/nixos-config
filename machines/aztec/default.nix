{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations = {
    aztec = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable

        config.flake.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
