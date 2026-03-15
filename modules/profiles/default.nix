{
  flake.nixosModules.profiles = {
    imports = [
      ./bare-metal.nix
      ./chat.nix
      ./core.nix
      ./server.nix
      ./desktop.nix
      ./laptop.nix
      ./media.nix
      ./gaming.nix
      ./development.nix
      ./work.nix
      ./hifiberry.nix
    ];
  };
}
