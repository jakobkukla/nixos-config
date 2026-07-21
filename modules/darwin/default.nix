{inputs, ...}: {
  imports = [
    # FIXME: vendored until https://github.com/nix-darwin/nix-darwin/pull/1690 is merged.
    ./vendor/nix-darwin.nix
    # inputs.nix-darwin.flakeModules.default
  ];

  flake.darwinModules.system = {
    imports = [
    ];

    config = {
      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    };
  };
}
