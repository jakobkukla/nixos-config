{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.profiles.work;
in {
  options.profiles.work = with lib; {
    enable = mkEnableOption "work profile";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.jakob = {
      home.packages = with pkgs; [
        # IDEs
        android-studio
        jetbrains.rider
        jetbrains.clion
        jetbrains.idea-community
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
