{config, ...}: {
  imports = [
    ./hardware
    ./home
    ./nixos
    ./profiles
  ];

  flake = {
    nixosModules.default = {
      imports = [
        # system modules
        config.flake.nixosModules.system

        # hardware modules
        config.flake.nixosModules.hardware

        # profiles
        config.flake.nixosModules.profiles

        # home-manager configuration
        config.flake.nixosModules.homeManagerConfiguration
      ];
    };
  };
}
