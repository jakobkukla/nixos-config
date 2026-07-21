{inputs, ...}: {
  config = {
    # Overlays
    nixpkgs.overlays = [inputs.self.overlays.default];

    # Allow proprietary packages
    nixpkgs.config.allowUnfree = true;
  };
}
