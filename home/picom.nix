{ ... }:

{
  home-manager.users.jakob = {
    services.picom = {
      fade = true;
      enable = true;
      vSync = true;
    };
  };
}
