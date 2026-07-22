{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  config = {
    programs.zsh.enable = true;

    home-manager.users.${config.modules.user.name} = hmArgs: {
      imports = [
        inputs.nix-index-database.homeModules.default
      ];

      home.packages = with pkgs;
        [
          onefetch
          sd
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [
          nitch
        ];

      programs.zsh = {
        enable = true;
        # Enable new dotDir behaviour (default as of home.stateVersion >= 26.05)
        dotDir = "${hmArgs.config.xdg.configHome}/zsh";
        shellAliases =
          {
            cat = "bat";
          }
          // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
            ip = "ip --color";
            # rescan wireless APs and open nmtui
            nmrt = "nmcli device wifi rescan; nmtui";
          };
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        historySubstringSearch = {
          enable = true;
          searchUpKey = "$terminfo[kcuu1]";
          searchDownKey = "$terminfo[kcud1]";
        };
      };

      programs.starship = {
        enable = true;
      };

      programs.nix-index = {
        enable = true;

        # Use small db for better performance.
        package = let
          system = pkgs.stdenv.hostPlatform.system;
        in
          inputs.nix-index-database.packages.${system}.nix-index-with-small-db;
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
