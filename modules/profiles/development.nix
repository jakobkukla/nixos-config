{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.profiles.development;
in {
  options.profiles.development = with lib; {
    enable = mkEnableOption "development profile";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.modules.user.name} = {
      home.packages = with pkgs; [
        gcc
        gnumake
        rustup
        gdb
        valgrind

        # IDEs
        android-studio
        jetbrains.rider
        jetbrains.clion
        jetbrains.idea-community

        # ADB
        android-tools
      ];

      modules.home = {
        languages = {
          ocaml.enable = true;
          latex.enable = true;
        };

        vscode = {
          enable = true;
        };
      };

      programs.zathura.enable = true;
    };
  };
}
