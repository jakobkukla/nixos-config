{ pkgs, nix-doom-emacs, ... }:

{
  home-manager.users.jakob = {
    imports = [ nix-doom-emacs.hmModule ];
    programs.doom-emacs = {
      enable = false;
      doomPrivateDir = ./dotfiles/doom.d;
    };

    home.packages = with pkgs; [
      (aspellWithDicts (dicts: with dicts; [ de ]))
    ];
  };
}
