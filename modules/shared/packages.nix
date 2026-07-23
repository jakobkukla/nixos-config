{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      wget
      htop
      python3
      libarchive
    ];
  };
}
