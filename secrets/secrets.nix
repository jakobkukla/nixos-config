let
  jakob = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWojtiUPbNshRKobtKSdt2Cp0HdHPn4qqpSzALSZ1rv jakob.kukla@gmail.com";
  users = [jakob];

  matebook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2PyNHnOUfdYWB0oFjuRZQ98/2biKQVy1jt4+vEAmiT root@nixos-matebook";
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUTEU+53xE6W+LQKsb0/L0Sn4A7c5lQynNF6yCn2I9I root@nixos-pc";
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPn5mXfQ1OWg70WbZKMttRGXDWRH7sPXGl67k88xSCIp root@nixos-server";
  systems = [matebook pc server];
in {
  "root.age".publicKeys = users ++ systems;
  "jakob.age".publicKeys = users ++ systems;
  "netrc-attic.age".publicKeys = users ++ systems;
  "spotify.age".publicKeys = users ++ systems;
}
