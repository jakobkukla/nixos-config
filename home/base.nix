{
  config,
  pkgs,
  inputs,
  ...
}: {
  # FIXME: remove unused imports statement
  imports = [
  ];

  home-manager.users.jakob = {
    # FIXME: this is temporary: import modules, find a better way to do that.
    imports = [
      # FIXME: I need to import the vscode-server module somewhere. inf rec if in vscode module?
      inputs.vscode-server.nixosModules.home

      ../modules/home-manager
    ];

    modules.home.shell.enable = true;
    modules.home.neovim.enable = true;
    modules.home.helix.enable = true;
    modules.home.spotify.enable = true;

    modules.home.languages = {
      ocaml.enable = true;
      latex.enable = true;
    };

    modules.home.vscode = {
      enable = true;
    };

    modules.home.firefox.enable = true;
    modules.home.batsignal.enable = true;
    modules.home.alacritty.enable = true;

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "jakob";
    home.homeDirectory = "/home/jakob";

    nixpkgs.overlays = import ../pkgs;
    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      #geogebra6
      discord
      nitch
      onefetch
      jellyfin-media-player
      signal-desktop
      element-desktop
      gomuks
      android-studio
      jetbrains.rider
      jetbrains.clion
      jetbrains.idea-community
      android-tools
      ffmpeg
      mpv
      easyeffects
      scrcpy
      grim
      rustdesk
      xpra
    ];

    xdg.enable = true;
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/ftp" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "text/xml" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
      };
    };

    services.dunst.enable = true;

    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = "jakobkukla";
      userEmail = "jakob.kukla@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    programs.zathura.enable = true;

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
