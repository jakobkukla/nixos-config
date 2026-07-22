{...}: {
  flake.sharedModules.system = {
    imports = [
      ./home-manager.nix
      ./nixpkgs.nix
      ./user.nix
      ./vcs.nix
    ];
  };
}
