{
  # deadnix: skip
  flake.overlays.default = final: prev: {
    # Overrides
    # old = prev.callPackage ./old.nix;
    hyprlandPlugins.csgo-vulkan-fix = prev.callPackage ./csgo-vulkan-fix.nix {};

    # New packages
    # new = final.callPackage ./new.nix;
  };
}
