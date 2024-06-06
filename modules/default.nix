{inputs, ...}: {
  imports = [
    # system modules
    ./system

    # profiles
    ./profiles
  ];

  # FIXME: this is stupid
  home-manager.users.jakob = {
    imports = [
      # home modules
      ./home

      # other
      inputs.vscode-server.nixosModules.home
    ];
  };
}
