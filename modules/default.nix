{
  config,
  inputs,
  ...
}: {
  imports = [
    # system modules
    ./nixos

    # hardware modules
    ./hardware

    # profiles
    ./profiles
  ];

  # FIXME: this is stupid
  home-manager.users.${config.modules.user.name} = {
    imports = [
      # home modules
      ./home

      # other
      inputs.vscode-server.nixosModules.home
      inputs.zen-browser.homeModules.beta
    ];
  };
}
