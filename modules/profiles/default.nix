{
  flake.nixosModules.profiles = {
    imports = [
      ./bare-metal.nix
      ./server.nix
      ./desktop.nix
      ./laptop.nix
      ./gaming.nix
      ./work.nix
    ];
  };
}
