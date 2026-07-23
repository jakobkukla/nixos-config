{...}: {
  flake.sharedModules.system = {
    imports = [
      ./gnupg.nix
      ./home-manager.nix
      ./locale.nix
      ./nix.nix
      ./nixpkgs.nix
      ./packages.nix
      ./secrets.nix
      ./shell.nix
      ./user.nix
      ./vcs.nix
    ];
  };
}
