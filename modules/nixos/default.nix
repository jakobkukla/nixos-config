{config, ...}: {
  flake.nixosModules.system = {
    imports = [
      ./user.nix
      ./shell.nix
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
      ./vcs.nix
    ];

    config = {
      # Overlays
      nixpkgs.overlays = [config.flake.overlays.default];

      # Allow proprietary packages
      nixpkgs.config.allowUnfree = true;
    };
  };
}
