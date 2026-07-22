{...}: {
  flake.nixosModules.system = {
    imports = [
      ./user.nix
      ./secrets.nix
      ./nix.nix
      ./filesystem.nix
      ./build-vm.nix
      ./greetd.nix
      ./neovim.nix
      ./sway.nix
      ./hyprland
      ./printer.nix
      ./eduroam.nix
      ./games
      ./librespot.nix
    ];
  };
}
