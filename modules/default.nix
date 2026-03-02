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

        # FIXME: this is stupid, again...
        # home modules
        {
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
        }

        # FIXME: preferably these would live right where they are used
        # other
        inputs.home-manager.nixosModules.home-manager
      ];
    };

    homeModules.default = {
      imports = [
        # local modules
        ./home
      ];
    };
  };
}
