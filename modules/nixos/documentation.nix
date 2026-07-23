{pkgs, ...}: {
  config = {
    # Linux/POSIX man pages.
    environment.systemPackages = with pkgs; [
      man-pages
      man-pages-posix
    ];
  };
}
