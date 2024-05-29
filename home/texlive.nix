{pkgs, ...}: {
  home-manager.users.jakob = {
    home.packages = with pkgs; [
      texlive.combined.scheme-full
      # language server
      texlab
      # another language server
      ltex-ls
    ];
  };
}
