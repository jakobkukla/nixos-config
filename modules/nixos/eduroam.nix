{
  lib,
  config,
  ...
}: let
  cfg = config.modules.eduroam;
in {
  options.modules.eduroam = with lib; {
    enable = mkEnableOption "eduroam HU Berlin";
  };

  config = let
    # eduroam HU Berlin certificate needed for TTLS
    eduroam-hu-ca = builtins.fetchurl {
      url = "https://pages.cms.hu-berlin.de/noc/pdfman/eduroam-hu-ca.pem";
      sha256 = "077vyh3k0lxdp09zl2bi95yiby9y2qrr0n3q8azc8ga6r0d22qhj";
    };
  in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = config.networking.networkmanager.enable;
          message = "`eduroam` configuration depends on NetworkManager";
        }
      ];

      networking.networkmanager.ensureProfiles = {
        environmentFiles = [
          # HU Berlin credentials
          config.age.secrets.eduroam.path
        ];

        profiles = {
          eduroam = {
            connection = {
              id = "eduroam";
              type = "wifi";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "eduroam";
            };
            wifi-security = {
              key-mgmt = "wpa-eap";
            };
            "802-1x" = {
              anonymous-identity = "eduroam@hu-berlin.de";
              eap = "ttls";
              identity = "$EDUROAM_HU_BERLIN_IDENTITY";
              password = "$EDUROAM_HU_BERLIN_PASSWORD";
              phase2-auth = "pap";
              ca-cert = eduroam-hu-ca;
            };
            ipv4 = {
              method = "auto";
            };
            ipv6 = {
              addr-gen-mode = "stable-privacy";
              method = "auto";
            };
          };
        };
      };
    };
}
