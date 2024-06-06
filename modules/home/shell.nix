{
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.home.shell = with lib; {
    enable = mkEnableOption "custom shell configuration";
  };

  config = lib.mkIf config.modules.home.shell.enable {
    home.packages = with pkgs; [
      nitch
      onefetch
      # FIXME: add zsh-history-substring here instead of globally
    ];

    programs.zsh = {
      enable = true;
      shellAliases = {
        cat = "bat";
        ip = "ip --color";
        # rescan wireless APs and open nmtui
        nmrt = "nmcli device wifi rescan; nmtui";
      };
      initExtra = ''
        source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
        bindkey "$terminfo[kcuu1]" history-substring-search-up
        bindkey "$terminfo[kcud1]" history-substring-search-down
      '';
    };

    programs.starship = {
      enable = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.eza.enable = true;
    programs.bat.enable = true;
    programs.ripgrep.enable = true;

    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = "jakobkukla";
      userEmail = "jakob.kukla@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };
}
