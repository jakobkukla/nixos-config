{ ... }:

{
  home-manager.users.jakob = {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 10;
            y = 10;
          };
        };

        background_opacity = 0.85;

        scrolling = {
          history = 1000;
          multiplier = 3;
        };

        font = {
          normal = {
            family = "Source Code Pro";
            style = "Regular";
          };

          bold = {
            family = "Source Code Pro";
            style = "Bold";
          };

          italic = {
            family = "Source Code Pro";
            style = "Italic";
          };

          bold_italic = {
            family = "Source Code Pro";
            style = "Bold Italic";
          };

          size = 9.0;
        };

        draw_bold_text_with_bright_colors = true;

        cursor.style.blinking = "On";
      };
    };
  };
}
