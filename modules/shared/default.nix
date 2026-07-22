{...}: {
  flake.sharedModules.system = {
    imports = [
      ./home-manager.nix
      ./nixpkgs.nix
      ./secrets.nix
      ./shell.nix
      ./user.nix
      ./vcs.nix
    ];
  };
}
