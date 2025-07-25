{pkgs, ...}:
{
  services.bind = {
    enable = true;
    cacheNetworks = [ "127.0.0.0/24" "::1/128" "192.168.16.0/24" "10.0.0.0/24" ];
    forward = "first";
    forwarders = [ "1.1.1.1" "2606:4700:4700::1111" ];
    zones = let hostip = "192.168.16.128"; wireguardip = "10.0.0.2"; in {
      "main-nixus.local" = {
        master = true;
        allowQuery = [ "127.0.0.0/24" "::1/128" "192.168.16.0/24" ];
        file = pkgs.writeText "zone-nixus.local" ''
            $ORIGIN nixus.local.
            $TTL    1d
            nixus.local  IN      SOA     ns1 hostmaster (
                                             1    ; Serial
                                             3h   ; Refresh
                                             1h   ; Update retry
                                             1w   ; Expire
                                             1h)  ; Negative Cache TTL
                         IN      NS      ns1

            nixus.local  IN      A       ${hostip}
                         IN      AAAA    2001:db8:113::1
                         IN      TXT     "v=spf1 mx"

            ns1          IN      A       ${hostip}

            www          IN      A       ${hostip}
            *            IN      A       ${hostip}
        '';
      };
      "wireguard-nixus.local" = {
        master = true;
        allowQuery = [ "10.0.0.0/24" ];
        file = pkgs.writeText "zone-nixus.local.wireguard" ''
            $ORIGIN nixus.local.
            $TTL    1d
            nixus.local  IN      SOA     ns1 hostmaster (
                                             1    ; Serial
                                             3h   ; Refresh
                                             1h   ; Update retry
                                             1w   ; Expire
                                             1h)  ; Negative Cache TTL
                         IN      NS      ns1

            nixus.local  IN      A       ${wireguardip}
                         IN      AAAA    2001:db8:113::1
                         IN      TXT     "v=spf1 mx"

            ns1          IN      A       ${wireguardip}

            www          IN      A       ${wireguardip}
            *            IN      A       ${wireguardip}
        '';
      };
    };
  };
}
