{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.neovim;
in {
  options.modules.neovim = with lib; {
    enable = mkEnableOption "Neovim text editor";

    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    home-manager.users.${config.modules.user.name} = {
      programs.neovim = {
        enable = true;

        defaultEditor = cfg.defaultEditor;

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
  };
}
