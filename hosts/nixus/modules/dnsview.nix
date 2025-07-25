{pkgs, ...}:
{
  systemd.tmpfiles.rules = [
    "d /run/named/logs - named root - -"
  ];
  services.bind = let
    hostip = "192.168.16.128";
    wireguardip = "172.30.202.2";
    wireguardSubnet = "172.30.202.0/24";
    zone-nixus = pkgs.writeText "zone-nixus.local" ''
      $TTL    1d
      $ORIGIN nixus.local.
      @            IN      SOA     ns1 hostmaster (
                                       1    ; Serial
                                       3h   ; Refresh
                                       1h   ; Update retry
                                       1w   ; Expire
                                       1h)  ; Negative Cache TTL
                   IN      NS      ns1

      @            IN      A       ${hostip}
                   IN      AAAA    2001:db8:113::1
                   IN      TXT     "v=spf1 mx"

      ns1          IN      A       ${hostip}

      www          IN      A       ${hostip}
      *            IN      A       ${hostip}
    '';
    zone-nixus-wireguard = pkgs.writeText "zone-nixus.local.wireguard" ''
      $TTL    1d
      $ORIGIN nixus.local.
      @            IN      SOA     ns1 hostmaster (
                                       1    ; Serial
                                       3h   ; Refresh
                                       1h   ; Update retry
                                       1w   ; Expire
                                       1h)  ; Negative Cache TTL
                   IN      NS      ns1

      @            IN      A       ${wireguardip}
                   IN      AAAA    2001:db8:113::1
                   IN      TXT     "v=spf1 mx"

      ns1          IN      A       ${wireguardip}

      www          IN      A       ${wireguardip}
      *            IN      A       ${wireguardip}
    '';
  in
    {
    enable = true;
    cacheNetworks = [ "127.0.0.0/24" "::1/128" "192.168.16.0/24" "${wireguardSubnet}" ];
    forward = "first";
    forwarders = [ "1.1.1.1" "2606:4700:4700::1111" ];
    extraConfig = ''
      acl "wireguard" { ${wireguardSubnet}; };
      acl "local" { 127.0.0.0/24; ::1/128; 192.168.16.0/24; };

      view "wireguard" {
        match-clients { "wireguard"; };
        zone "nixus.local" {
          type master;
          file "${zone-nixus-wireguard}";
        };
      };

      view "default" {
        match-clients { "local"; };
        zone "nixus.local" {
          type master;
          file "${zone-nixus}";
        };
      };

      logging {
        channel my_syslog {
            syslog daemon;
            severity notice;
        };
        channel my_file {
            file "/run/named/logs/messages";
            severity info;
            print-time yes;
        };
        # channel to log all zone transfers:
        channel my_xfer_file {
            file "/run/named/logs/xfers";
            severity info;
            print-time yes;
        };
        # channel to log all dynamic updates:
        channel my_update_file {
            file "/run/named/logs/updates";
            severity info;
            print-time yes;
        };
        category default { my_file; };
        category update { my_update_file; };
        category xfer-in { my_xfer_file; };
        category xfer-out { my_xfer_file; };
      };
    '';
  };
}
