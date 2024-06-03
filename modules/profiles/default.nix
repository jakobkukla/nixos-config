{
  imports = [
    # modules
    ../nixos
    #../home-manager

    # profiles
    ./chat.nix
    ./core.nix
    ./gui.nix
    ./laptop.nix
    ./media.nix
    ./work.nix
  ];

  # FIXME: this is stupid
  home-manager.users.jakob = {
    imports = [
      ../home-manager
    ];
  };
}
