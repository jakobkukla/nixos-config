{...}: {
  flake.sharedModules.system = {
    imports = [
      ./home-manager.nix
      ./nixpkgs.nix
      ./shell.nix
      ./user.nix
      ./vcs.nix
    ];
  };
}
