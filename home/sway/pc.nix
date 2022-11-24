{ ... }:

{
  imports =
    [
      ./base.nix
    ];

  home-manager.users.jakob = {
    wayland.windowManager.sway = {
      config = {
        output = {
          DP-1 = {
            res = "2560x1440@143.964005Hz";
            pos = "0 0";
          };
          DP-2 = {
            res = "3840x2160@59.951000Hz";
            pos = "2560 0";
            scale = "1.5";
          };
        };
      };
    };
  };
}

