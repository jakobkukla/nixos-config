{
  config,
  inputs,
  ...
}: {
  imports = [
    ./darwin
    ./home
    ./nixos
    ./profiles
    ./shared
  ];

  flake = {
    nixosModules.default = {
      imports = [
        # home-manager module
        inputs.home-manager.nixosModules.home-manager

        # shared modules
        config.flake.sharedModules.system

        # system modules
        config.flake.nixosModules.system

        # profiles
        config.flake.nixosModules.profiles
      ];
    };

    darwinModules.default = {
      imports = [
        # home-manager module
        inputs.home-manager.darwinModules.home-manager

        # shared modules
        config.flake.sharedModules.system

        # system modules
        config.flake.darwinModules.system
      ];
    };
  };
}
