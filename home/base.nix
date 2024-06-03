{
  config,
  pkgs,
  inputs,
  ...
}: {
  home-manager.users.jakob = {
    imports = [
      # FIXME: I need to import the vscode-server module somewhere. inf rec if in vscode module?
      inputs.vscode-server.nixosModules.home
    ];

    # FIXME: where to put this? currently all defaultApps declarations live in the firefox module
    xdg.mimeApps.enable = true;

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "21.11";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
