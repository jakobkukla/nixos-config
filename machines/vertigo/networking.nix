{
  lib,
  config,
  ...
}: let
  cfg = config.machines.vertigo.networking;

  addressOptions = {
    options = {
      address = lib.mkOption {
        type = lib.types.str;
        description = ''
          The IP address.
        '';
      };
      prefixLength = lib.mkOption {
        type = lib.types.int;
        description = ''
          The subnet mask.
        '';
      };
    };
  };
in {
  options.machines.vertigo.networking = {
    ipv4 = lib.mkOption {
      type = lib.types.submodule addressOptions;
      description = ''
        The static IPv4 address configuration.
      '';
    };

    ipv6 = lib.mkOption {
      type = lib.types.submodule addressOptions;
      description = ''
        The static IPv6 address configuration.
      '';
    };
  };

  config = {
    systemd.network = {
      enable = true;

      networks."10-wan" = {
        matchConfig.Name = "enp1s0";
        networkConfig.DHCP = "no";

        address = [
          "${cfg.ipv4.address}/${toString cfg.ipv4.prefixLength}"
          "${cfg.ipv6.address}/${toString cfg.ipv6.prefixLength}"
        ];

        routes = [
          {
            Gateway = "172.31.1.1";
            GatewayOnLink = true;
          }
          {
            Gateway = "fe80::1";
          }
        ];
      };
    };

    # Disable DHCP as we use networkd
    networking.useDHCP = false;

    networking.hostName = "vertigo";
    networking.firewall.enable = true;
  };
}
