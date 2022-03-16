{ nix-doom-emacs, ... }:

{
  home-manager.users.jakob = {
    imports = [ nix-doom-emacs.hmModule ];
    programs.doom-emacs = {
      enable = true;
      doomPrivateDir = ./dotfiles/doom.d;
    };
  };
}
