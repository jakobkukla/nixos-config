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
          home-manager.sharedModules = [
            config.flake.homeModules.default
          ];
        }

        # FIXME: preferably these would live right where they are used
        # other
        inputs.impermanence.nixosModules.impermanence
        inputs.home-manager.nixosModules.home-manager
        inputs.agenix.nixosModules.default
      ];
    };

    homeModules.default = {
      imports = [
        # local modules
        ./home

        # FIXME: preferably these would live right where they are used
        # other
        inputs.vscode-server.nixosModules.home
        inputs.zen-browser.homeModules.beta
      ];
    };
  };
}
