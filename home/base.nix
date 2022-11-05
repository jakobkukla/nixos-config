{ config, pkgs, ... }:

{
  imports =
    [
      ./services
      ./alacritty.nix
      ./firefox.nix
      ./vscode.nix
      ./texlive.nix
    ];

  home-manager.users.jakob = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "jakob";
    home.homeDirectory = "/home/jakob";

    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      #geogebra6
      discord
      neofetch
      onefetch
      spotify
      spotify-tui
      jellyfin-media-player
      signal-desktop
      element-desktop
      android-studio
      dotnet-sdk
      jetbrains.rider
      jetbrains.clion
      jetbrains.idea-community
      android-tools
      ffmpeg
      mpv
      easyeffects
      scrcpy
    ];

    xdg.enable = true;
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };

    services.dunst.enable = true;

    programs.zsh = {
      enable = true;
      shellAliases = {
        cat = "bat";
      };
      initExtra = ''
source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

PS1="%B%F{blue}%n%F{red}@%F{green}%m%f:%F{blue}%~ %b%f$ "
      '';
    };

    programs.neovim = {
      enable = true;
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

    programs.git = {
      enable = true;
      userName = "jakobkukla";
      userEmail = "jakob.kukla@gmail.com";
    };

    programs.exa = {
      enable = true;
      enableAliases = true;
    };

    programs.bat.enable = true;

    programs.zathura.enable = true;

    services.mpris-proxy.enable = true;
    services.spotifyd = {
      enable = true;
      package = pkgs.spotifyd.override {
        withPulseAudio = true;
        withMpris = true;
      };
      settings = {
        global = {
          username = "der_kukla";
          password_cmd = "cat ${config.age.secrets.spotify.path}";
          backend = "pulseaudio";
          device_name = "${config.networking.hostName}";
          bitrate = 320;
          use_mpris = true;
          cache_path = "/home/jakob/.cache/spotifyd";
          volume-normalisation = true;
          normalisation-pregain = -10;
          device_type = "computer";
        };
      };
    };
    
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
}

