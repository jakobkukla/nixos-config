let
  jakob_matebook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWojtiUPbNshRKobtKSdt2Cp0HdHPn4qqpSzALSZ1rv jakob.kukla@gmail.com";
  jakob_pc       = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF2x/yGLqIfEvjU7p7gRmbqC8NgK2TIuyaKg/TL1Dt5e jakob@nixos-pc";

  jakob = [ jakob_matebook jakob_pc ];
  users = jakob;

  matebook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2PyNHnOUfdYWB0oFjuRZQ98/2biKQVy1jt4+vEAmiT root@nixos-matebook";
  pc       = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUTEU+53xE6W+LQKsb0/L0Sn4A7c5lQynNF6yCn2I9I root@nixos-pc";
  systems = [ matebook pc ];
in
{
  "root.age".publicKeys = systems;
  "jakob.age".publicKeys = jakob ++ systems;
  "spotify.age".publicKeys = users ++ systems;
}
