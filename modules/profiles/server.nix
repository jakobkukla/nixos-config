{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.profiles.server;
in {
  options.profiles.server = with lib; {
    enable = mkEnableOption "server profile";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tmux
    ];

    # Print the URL instead on servers
    environment.variables.BROWSER = "echo";

    # Enable BBR congestion control
    boot.kernelModules = ["tcp_bbr"];
    boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
    boot.kernel.sysctl."net.core.default_qdisc" = "fq"; # see https://news.ycombinator.com/item?id=14814530
  };
}
