{
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.home.neovim = with lib; {
    enable = mkEnableOption "Neovim text editor";

    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.modules.home.neovim.enable {
    programs.neovim = {
      enable = true;

      defaultEditor = config.modules.home.neovim.defaultEditor;

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
    };
  };
}
