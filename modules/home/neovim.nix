{pkgs, ...}: {
  config = {
    programs.neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;

      extraConfig = ''
        set number
        highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

        set tabstop=4
        set shiftwidth=4
      '';

      plugins = with pkgs.vimPlugins; [
        vim-nix
      ];

      # Disable ruby plugin provider (default as of home.stateVersion >= 26.05)
      withRuby = false;
      # Disable python3 plugin provider (default as of home.stateVersion >= 26.05)
      withPython3 = false;
    };
  };
}
