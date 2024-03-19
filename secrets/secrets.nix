let
  jakob = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWojtiUPbNshRKobtKSdt2Cp0HdHPn4qqpSzALSZ1rv jakob.kukla@gmail.com";
  users = [jakob];

  matebook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2PyNHnOUfdYWB0oFjuRZQ98/2biKQVy1jt4+vEAmiT root@nixos-matebook";
  systems = [matebook];
in {
  "root.age".publicKeys = systems;
  "jakob.age".publicKeys = [jakob] ++ systems;
  "netrc-attic.age".publicKeys = users ++ systems;
  "spotify.age".publicKeys = users ++ systems;
}
