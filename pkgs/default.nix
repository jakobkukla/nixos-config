{
  # deadnix: skip
  flake.overlays.default = final: prev: {
    # Overrides
    # old = prev.callPackage ./old.nix;

    # New packages
    # new = final.callPackage ./new.nix;
  };
}
