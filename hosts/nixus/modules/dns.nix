{pkgs, ...}:
{
  services.bind = {
    enable = true;
    cacheNetworks = [ "127.0.0.0/24" "::1/128" "192.168.4.0/22" ];
    forward = "first";
    forwarders = [ "1.1.1.1" "2606:4700:4700::1111" ];
    zones = {
      "nixus.local" = {
        master = true;
        allowQuery = [ "127.0.0.0/24" "::1/128" "192.168.4.0/22" ];
        file = pkgs.writeText "zone-nixus.local" ''
          $ORIGIN nixus.local.
          $TTL    1d
          @            IN      SOA     ns1 hostmaster (
                                           1    ; Serial
                                           3h   ; Refresh
                                           1h   ; Update retry
                                           1w   ; Expire
                                           1h)  ; Negative Cache TTL
                       IN      NS      ns1

          @            IN      A       192.168.7.179
                       IN      AAAA    2001:db8:113::1
                       IN      TXT     "v=spf1 mx"

          ns1          IN      A       192.168.7.179

          www          IN      A       192.168.7.179
          *            IN      A       192.168.7.179
        '';
      };
    };
  };
}
