{inputs, ...}: {
  config = {
    home-manager = {
      sharedModules = [
        inputs.self.homeModules.default
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
}
