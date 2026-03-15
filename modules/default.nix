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

    # FIXME: ideally this would live somewhere else
    nixosModules.homeManagerConfiguration = {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      config = {
        home-manager = {
          sharedModules = [
            config.flake.homeModules.default
          ];

          # Use NixOS pkgs instance (including its settings and overlays).
          useGlobalPkgs = true;
          # Use NixOS to install user packages.
          useUserPackages = true;

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
