{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.secrets;
in {
  options.modules.secrets = with lib; {
    enable =
      mkEnableOption "secrets module"
      // {
        default = true;
      };

    # TODO: disable secrets, e.g. spotify, if corresponding module is not used
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    age = {
      # Use real key file on ephemeral root systems
      identityPaths =
        if config.modules.filesystem.enableImpermanence
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
      };
    };

    home-manager.users.${config.modules.user.name} = {
      home.shellAliases = {
        # FIXME: \sudo (might not work in other shells) and remove EDITOR variable. fix sudo in general.
        "agenix" = "\sudo EDITOR=${config.environment.variables."EDITOR"} agenix -i /etc/ssh/ssh_host_ed25519_key";
      };
    };
  };
}
