{
  lib,
  cmake,
  fetchFromGitHub,
  pkg-config,
  # deadnix: skip
  hyprland,
} @ topLevelArgs: let
  mkHyprlandPlugin = lib.extendMkDerivation {
    constructDrv = topLevelArgs.hyprland.stdenv.mkDerivation;

    # deadnix: skip
    extendDrvArgs = finalAttrs: {
      pluginName ? "",
      nativeBuildInputs ? [],
      buildInputs ? [],
      hyprland ? topLevelArgs.hyprland,
      ...
    } @ args: {
      pname = "${pluginName}";
      nativeBuildInputs = [pkg-config] ++ nativeBuildInputs;
      buildInputs = [hyprland] ++ hyprland.buildInputs ++ buildInputs;
      meta =
        args.meta
        // {
          description = args.meta.description or "";
          longDescription =
            (args.meta.longDescription or "")
            + "\n\nPlugins can be installed via a plugin entry in the Hyprland NixOS or Home Manager options.";

          platforms = args.meta.platforms or hyprland.meta.platforms or [];
        };
    };
  };

  version = "b85a56b";

  hyprland-plugins-src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland-plugins";
    rev = version;
    hash = "sha256-xwNa+1D8WPsDnJtUofDrtyDCZKZotbUymzV/R5s+M0I=";
  };
in
  mkHyprlandPlugin (finalAttrs: {
    pluginName = "csgo-vulkan-fix";
    inherit version;

    src = "${hyprland-plugins-src}/${finalAttrs.pluginName}";
    nativeBuildInputs = [cmake];
    meta = {
      homepage = "https://github.com/hyprwm/hyprland-plugins";
      description = "Hyprland CS:GO/CS2 Vulkan fix plugin";
      license = lib.licenses.bsd3;
      teams = [lib.teams.hyprland];
    };
  })
