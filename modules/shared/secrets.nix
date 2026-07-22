{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    # `nixosModules.default` and `darwinModules.default` point to the same
    # platform-aware module, so this works on nix-darwin too.
    inputs.agenix.nixosModules.default
  ];

  # TODO: disable secrets, e.g. spotify, if corresponding module is not used
  config = {
    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    age = {
      # Use real key file on ephemeral root systems
      identityPaths =
        if pkgs.stdenv.hostPlatform.isLinux && config.modules.filesystem.enableImpermanence
        then [
          "/persist/etc/ssh/ssh_host_ed25519_key"
        ]
        else [
          "/etc/ssh/ssh_host_ed25519_key"
        ];

      # Secrets
      secrets = {
        root.file = ../../secrets/root.age;
        # TODO: use ${config.modules.user.name} here instead.
        ${config.modules.user.name}.file = ../../secrets/jakob.age;
        netrc-attic.file = ../../secrets/netrc-attic.age;
        spotify = {
          file = ../../secrets/spotify.age;
          owner = config.modules.user.name;
        };
        eduroam = {
          file = ../../secrets/eduroam.age;
          owner = "root";
          group = "root";
        };
        soju = {
          file = ../../secrets/soju.age;
          owner = config.modules.user.name;
        };
      };
    };
  };
}
