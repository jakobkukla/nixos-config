{
  flake.nixosModules.hardware = {
    imports = [
      ./hifiberry
    ];
  };
}
