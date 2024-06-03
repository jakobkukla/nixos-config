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
  };
}
