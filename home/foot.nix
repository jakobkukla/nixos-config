{ ... }:

{
  home-manager.users.jakob = {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          pad = "10x10";
          font = "Source Code Pro:size=12";
          bold-text-in-bright = "palette-based";
        };

        # TODO: consider removing the scroll bar

        # FIXME: remove this as these are already the defaults
        scrollback = {
          lines = 1000;
          multiplier = 3.0;
        };

        cursor.blink = "yes";

        # TODO: fix vim status bar fg color
        colors = {
          alpha = 0.85;

          # use alacritty color-scheme
          foreground = "c5c8c6";
          background = "1d1f21";

          regular0 = "1d1f21";  # black
          regular1 = "cc6666";  # red
          regular2 = "b5bd68";  # green
          regular3 = "f0c674";  # yellow
          regular4 = "81a2be";  # blue
          regular5 = "b294bb";  # magenta
          regular6 = "8abeb7";  # cyan
          regular7 = "c5c8c6";  # white

          bright0 = "666666";   # bright black
          bright1 = "d54e53";   # bright red
          bright2 = "b9ca4a";   # bright green
          bright3 = "e7c547";   # bright yellow
          bright4 = "7aa6da";   # bright blue
          bright5 = "c397d8";   # bright magenta
          bright6 = "70c0b1";   # bright cyan
          bright7 = "eaeaea";   # bright white
        };
      };
    };
  };
}
