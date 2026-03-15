{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeModules.default = {
    imports = [
      ./default-applications.nix
      ./alacritty.nix
      ./rofi.nix
      ./languages
      ./helix.nix
      ./vscode.nix
      ./browsers
      ./spotify.nix
      ./bitwarden.nix
      ./senpai.nix
    ];
  };

  flake.nixosModules.homeManagerConfiguration = {
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
}
