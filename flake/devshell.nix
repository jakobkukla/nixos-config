{inputs, ...}: {
  imports = [
    inputs.devenv.flakeModule
  ];

  perSystem = {
    devenv.shells.default = {
      languages.nix.enable = true;

      git-hooks.hooks = {
        actionlint.enable = true;
        alejandra.enable = true;
        check-merge-conflicts.enable = true;
        commitizen.enable = true;
        deadnix.enable = true;
        markdownlint.enable = true;
      };
    };
  };
}
