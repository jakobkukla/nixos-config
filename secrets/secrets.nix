let
  matebook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWojtiUPbNshRKobtKSdt2Cp0HdHPn4qqpSzALSZ1rv jakob.kukla@gmail.com";

  systems = [ matebook ];
in
{
  "spotify.age".publicKeys = systems;
}
