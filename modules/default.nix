{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake = {
    nixosModules.default = {
      imports = [
        # system modules
        ./nixos

        # hardware modules
        ./hardware

        # profiles
        ./profiles

        # home modules
        config.flake.nixosModules.homeManagerConfiguration
      ];
    };

    nixosModules.homeManagerConfiguration = {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      config = {
        home-manager = {
          sharedModules = [
            config.flake.homeModules.default
          ];

          # Only needed, if we want to access `inputs` from pure hm modules
          # (not flake or nixos modules).
          extraSpecialArgs = {
            inherit inputs;
          };
        };
      };
    };

    homeModules.default = {
      imports = [
        # local modules
        ./home
      ];
    };
  };
}
