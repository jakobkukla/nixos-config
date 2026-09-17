{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.device.role == "server") {
    # Enable BBR congestion control
    boot.kernelModules = ["tcp_bbr"];
    boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
    boot.kernel.sysctl."net.core.default_qdisc" = "fq"; # see https://news.ycombinator.com/item?id=14814530
  };
}
