{pkgs, ...}:
{
  systemd.tmpfiles.rules = [
    "d /run/named/logs - named root - -"
  ];
  services.bind = let
    hostip = "192.168.16.2";
    hostipv6 = "2601:19b:107f:4f20::2";
    routerip = "192.168.16.1";
    wireguardip = "172.30.202.2";
    wireguardSubnet = "172.30.202.0/24";

    # nixus.local
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
                   IN      AAAA    ${hostipv6}
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
                   IN      TXT     "v=spf1 mx"

      ns1          IN      A       ${wireguardip}

      www          IN      A       ${wireguardip}
      *            IN      A       ${wireguardip}
    '';

    # home.arpa
    zone-home = pkgs.writeText "zone-home.arpa" ''
      $TTL    1d
      $ORIGIN home.arpa.
      @            IN      SOA     ns1 hostmaster (
                                       1    ; Serial
                                       3h   ; Refresh
                                       1h   ; Update retry
                                       1w   ; Expire
                                       1h)  ; Negative Cache TTL
                   IN      NS      ns1

      @            IN      A       ${hostip}
                   IN      AAAA    ${hostipv6}
                   IN      TXT     "v=spf1 mx"

      ns1          IN      A       ${hostip}

      router       IN      A       ${routerip}

      nixus        IN      A       ${hostip}
                   IN      AAAA    ${hostipv6}
      www          IN      A       ${hostip}
                   IN      AAAA    ${hostipv6}
      jellyfin     IN      A       ${hostip}
                   IN      AAAA    ${hostipv6}
      arr          IN      A       ${hostip}
                   IN      AAAA    ${hostipv6}
      seer         IN      A       ${hostip}
                   IN      AAAA    ${hostipv6}
      paperless    IN      A       ${hostip}
                   IN      AAAA    ${hostipv6}
      immich       IN      A       ${hostip}
                   IN      AAAA    ${hostipv6}
      mainsail     IN      A       ${hostip}
                   IN      AAAA    ${hostipv6}
      *            IN      A       ${hostip}
                   IN      AAAA    ${hostipv6}
    '';
    zone-home-wireguard = pkgs.writeText "zone-home.arpa.wireguard" ''
      $TTL    1d
      $ORIGIN home.arpa.
      @            IN      SOA     ns1 hostmaster (
                                       1    ; Serial
                                       3h   ; Refresh
                                       1h   ; Update retry
                                       1w   ; Expire
                                       1h)  ; Negative Cache TTL
                   IN      NS      ns1

      @            IN      A       ${wireguardip}
                   IN      TXT     "v=spf1 mx"

      ns1          IN      A       ${wireguardip}

      www          IN      A       ${wireguardip}
      paperless    IN      A       ${wireguardip}
      jellyfin     IN      A       ${wireguardip}
      arr          IN      A       ${wireguardip}
      seer         IN      A       ${wireguardip}
      immich       IN      A       ${wireguardip}
      mainsail     IN      A       ${wireguardip}
      *            IN      A       ${wireguardip}
    '';
    zone-cadenp = pkgs.writeText "zone-cadenp.com" ''
      $TTL    1m
      $ORIGIN cadenp.com.
      @            IN      SOA     ns1 hostmaster (
                                       1    ; Serial
                                       3h   ; Refresh
                                       1h   ; Update retry
                                       1w   ; Expire
                                       1h)  ; Negative Cache TTL
                   IN      NS      ns1

      @            IN      A       ${hostip}
                   IN      AAAA    ${hostipv6}
                   IN      TXT     "v=spf1 mx"

      ns1          IN      A       ${hostip}

      www          IN      A       ${hostip}
      remote       IN      A       ${hostip}
      *            IN      A       ${hostip}
    '';
  in
    {
    enable = true;
    cacheNetworks = [ "127.0.0.0/24" "::1/128" "fd00::/8" "192.168.16.0/24" "${wireguardSubnet}" ];
    forward = "first";
    # forwarders = [ "1.1.1.1" "2606:4700:4700::1111" ];

    # Forward to blocky
    forwarders = [ "127.0.0.1 port 54" "::1 port 54" ];
    extraConfig = ''
      acl "wireguard" { ${wireguardSubnet}; };
      acl "local" { 127.0.0.0/24; ::1/128; fd00::/8; 192.168.16.0/24; };

      view "wireguard" {
        match-clients { "wireguard"; };
        zone "nixus.local" {
          type master;
          file "${zone-nixus-wireguard}";
        };
        zone "home.arpa" {
          type master;
          file "${zone-home-wireguard}";
        };
      };

      view "default" {
        match-clients { "local"; };
        zone "nixus.local" {
          type master;
          file "${zone-nixus}";
        };
        zone "home.arpa" {
          type master;
          file "${zone-home}";
        };
        zone "cadenp.com" {
          type master;
          file "${zone-cadenp}";
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
