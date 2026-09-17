{inputs, ...}: {
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeModules.default = {
    imports = [
      ./alacritty.nix
      ./bitwarden.nix
      ./browsers
      ./chat.nix
      ./default-applications.nix
      ./development.nix
      ./helix.nix
      ./languages
      ./media.nix
      ./neovim.nix
      ./rofi.nix
      ./senpai.nix
      ./spotify.nix
      ./vscode.nix
    ];

    config = {
      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      home.stateVersion = "21.11";

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
  };
}
