{
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.shell = with lib; {
    enable = mkEnableOption "custom shell configuration";
  };

  config = lib.mkIf config.modules.shell.enable {
    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        sudo = "sudo -E -s ";
      };
    };

    home-manager.users.${config.modules.user.name} = hmArgs: {
      home.packages = with pkgs; [
        nitch
        onefetch
      ];

      programs.zsh = {
        enable = true;
        # Enable new dotDir behaviour (default as of home.stateVersion >= 26.05)
        dotDir = "${hmArgs.config.xdg.configHome}/zsh";
        shellAliases = {
          cat = "bat";
          ip = "ip --color";
          # rescan wireless APs and open nmtui
          nmrt = "nmcli device wifi rescan; nmtui";
        };
        historySubstringSearch = {
          enable = true;
          searchUpKey = "$terminfo[kcuu1]";
          searchDownKey = "$terminfo[kcud1]";
        };
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
    };
  };
}
