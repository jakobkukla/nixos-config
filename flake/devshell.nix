{inputs, ...}: {
  imports = [
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem = {
    pkgs,
    config,
    ...
  }: {
    pre-commit.settings.hooks = {
      actionlint.enable = true;
      alejandra.enable = true;
      check-merge-conflicts.enable = true;
      commitizen.enable = true;
      deadnix.enable = true;
      markdownlint.enable = true;
    };

    devShells.default = pkgs.mkShell {
      inputsFrom = [config.pre-commit.devShell];

      packages = with pkgs; [
        # LSP
        nixd
      ];
    };
  };
}
