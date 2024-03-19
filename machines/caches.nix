{config, ...}: {
  # Use personal binary cache and nixos cache
  nix.settings = {
    substituters = [
      "https://cache.nixos.org?priority=40"
      "https://nix-community.cachix.org?priority=41"
      "https://numtide.cachix.org?priority=42"
      "https://jakobkukla.cachix.org?priority=43"
      "https://attic.jakobkukla.xyz/system?priority=44"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "jakobkukla.cachix.org-1:Wk6Y2/s1YlTwsZKCs46v9uYejYUnVdzXTXzbJbYv+1s="
      "system:7gMaV5t8G5VkXhIOs8yV/divVtfZ90aXu4Wo0bYpIG8="
    ];

    # Netrc file for private cache authentication
    netrc-file = config.age.secrets.netrc-attic.path;
  };
}
