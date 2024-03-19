# Borrowed from fufexan (https://github.com/fufexan/dotfiles/blob/main/home/editors/helix/default.nix)
{...}: {
  home-manager.users.jakob = {
    programs.helix = {
      enable = true;

      settings = {
        theme = "catppuccin_mocha";
        editor = {
          whitespace.characters = {
            newline = "↴";
            tab = "⇥";
          };
        };

        keys.normal.space.u = {
          f = ":format"; # format using LSP formatter
          w = ":set whitespace.render all";
          W = ":set whitespace.render none";
        };
      };
    };
  };
}
