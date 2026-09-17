{...}: {
  flake.sharedModules.system = {
    imports = [
      ./device.nix
      ./gnupg.nix
      ./home-manager.nix
      ./locale.nix
      ./nix.nix
      ./nixpkgs.nix
      ./packages.nix
      ./roles
      ./secrets.nix
      ./shell.nix
      ./user.nix
      ./vcs.nix
    ];
  };
}
