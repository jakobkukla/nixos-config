let
  jakob = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWojtiUPbNshRKobtKSdt2Cp0HdHPn4qqpSzALSZ1rv jakob@aztec";
  users = [jakob];

  aztec = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2PyNHnOUfdYWB0oFjuRZQ98/2biKQVy1jt4+vEAmiT root@aztec";
  cache = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPn5mXfQ1OWg70WbZKMttRGXDWRH7sPXGl67k88xSCIp root@cache";
  inferno = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPS0BKlAHc/ev1+oNpPsfp046IPWwijHXf9J9NoLNQ6I root@inferno";
  mirage = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUTEU+53xE6W+LQKsb0/L0Sn4A7c5lQynNF6yCn2I9I root@mirage";
  triton = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9RUHt1rxIADSQJkrjzbKwdNLZKbzBZDkCwi7x00frB root@moxz-triton";
  systems = [aztec cache inferno mirage triton];
in {
  "root.age".publicKeys = users ++ systems;
  "jakob.age".publicKeys = users ++ systems;
  "pi.age".publicKeys = users ++ systems;
  "netrc-attic.age".publicKeys = users ++ systems;
  "spotify.age".publicKeys = users ++ systems;
  "eduroam.age".publicKeys = users ++ systems;
  "soju.age".publicKeys = users ++ systems;
}
