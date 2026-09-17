{
  config,
  inputs,
  lib,
  ...
}: {
  flake.githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
    checks = lib.zipAttrsWith (_: lib.mergeAttrsList) (lib.mapAttrsToList (name: machine: {
      ${machine.config.nixpkgs.hostPlatform.system}.${name} = machine.config.system.build.toplevel;
    }) (config.flake.nixosConfigurations // config.flake.darwinConfigurations));
  };
}
