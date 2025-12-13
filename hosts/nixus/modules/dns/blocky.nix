{pkgs, ...}:
{
  systemd.tmpfiles.rules = [
    "d /run/named/logs - named root - -"
  ];
  services.blocky = let
    hostip = "192.168.16.2";
    hostipv6 = "2601:19b:200:1534::e5b";
    routerip = "192.168.16.1";
    wireguardip = "172.30.202.2";
    wireguardSubnet = "172.30.202.0/24";
  in {
    enable = true;
    settings = {
      ports = {
        dns = 54;
        # tls = 853;
        http = 4000;
      };

      upstreams = {
        groups.default = [
          "tcp-tls:dns.quad9.net"
          "tcp-tls:one.one.one.one"
        ];
        strategy = "parallel_best";
        init.strategy = "fast";
      };
      bootstrapDns = [
        { upstream = "9.9.9.9"; }
        { upstream = "1.1.1.1"; }
      ];

      caching = {
        prefetching = true;
        prefetchMaxItemsCount = 1000;
        prefetchExpires = "1h";
        prefetchThreshold = 5;
      };

      blocking = {
        denylists = {
          normal = [
            "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/multi.txt"
            "https://big.oisd.nl/domainswild"
          ];
          nsfw = [
            "https://nsfw-small.oisd.nl/domainswild"
          ];
        };
        # allowlists = {
        #   normal = [ ];
        # };
        clientGroupsBlock = {
          default = [ "normal" "nsfw" ];
        };
      };

      prometheus = {
        enable = true;
        path = "/metrics";
      };

      log.level = "warn";
    };
  };
}
