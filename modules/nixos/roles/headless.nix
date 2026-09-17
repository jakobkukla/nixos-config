{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf config.device.headless {
    environment.systemPackages = with pkgs; [
      tmux
    ];

    # Print the URL instead on headless machines
    environment.variables.BROWSER = "echo";
  };
}
