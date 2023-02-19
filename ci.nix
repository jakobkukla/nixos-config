let
  outputs = builtins.getFlake (toString ./.);
  pkgs = outputs.inputs.nixpkgs;
  drvs = pkgs.lib.collect pkgs.lib.isDerivation outputs.nixosConfigurations.matebook.config.system.build.toplevel;
in
  drvs
