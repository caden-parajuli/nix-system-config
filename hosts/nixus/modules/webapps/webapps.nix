{pkgs, ...}:
{
  imports = [
    ./arr.nix
    ./immich.nix
    ./paperless.nix
    ./syncthing.nix
    ./xwiki.nix

    ./webremote.nix

    ./monitoring.nix
  ];
  users.groups.media.members = [
    "caden"

    "paperless"
    "immich"
    "jellyfin"

    "lidarr"
    "sonarr"
    "radarr"
    "readarr"

    "transmission"
    "syncthing"
  ];

  # Kernel params for Nginx
  boot.kernel.sysctl."net.ipv4.tcp_tw_reuse" = 1;
  boot.kernel.sysctl."net.ipv4.tcp_fin_timeout" = 15;

  # Lower latency/early throughput
  boot.kernel.sysctl."net.ipv4.tcp_low_latency" = 1;
  boot.kernel.sysctl."tcp_slow_start_after_idle" = 0;
  # Send data during the TCP handshake
  boot.kernel.sysctl."net.ipv4.tcp_fastopen" = 3;

  # Better TCP throughput
  boot.kernelModules = [ "tcp_bbr" ];
  boot.kernel.sysctl."net.ipv4.tcp_available_congestion_control" = "bbr";
  boot.kernel.sysctl."net.core.default_qdisc" = "fq";

  # Disable SACK
  boot.kernel.sysctl."net.ipv4.tcp_sack" = 0;
  boot.kernel.sysctl."net.ipv4.tcp_dsack" = 0;

  services.nginx =
    let
      proxy = port: extra: {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true;
      } // extra;
      proxy_s = port: extra: {
        proxyPass = "https://127.0.0.1:${toString port}";
        proxyWebsockets = true;
      } // extra;
      handleErrors = host: pkgs.lib.recursiveUpdate host {
        locations."/error" = {
          priority = 10;
          root = "/var/www/nixus";
          extraConfig = "internal;";
        };

        extraConfig = pkgs.lib.concatStringsSep "\n" [
          (host.extraConfig or "")
          ''
            proxy_intercept_errors on;
            error_page 403 /error/403.html;
            error_page 404 /error/404.html;
            error_page 500 501 502 503 504 /error/5xx.html;
        ''];
       };
    in rec {
      enable = true;
      additionalModules = [ ]; # pkgs.nginxModules.pam
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedBrotliSettings = true;
      experimentalZstdSettings = true;

      recommendedProxySettings = true;

      # XWiki
      virtualHosts."xwiki.home.arpa" = handleErrors {
        locations."/" = {
          extraConfig = ''return 301 http://xwiki.home.arpa/xwiki;'';
        };
        locations."/xwiki" = {
          proxyPass = "http://127.0.0.1:8080/xwiki";
          proxyWebsockets = true;
        };
      };
      virtualHosts."xwiki.nixus.local" = handleErrors {
        locations."/" = {
          extraConfig = ''return 301 http://xwiki.nixus.local/xwiki;'';
        };
        locations."/xwiki" = {
          proxyPass = "http://127.0.0.1:8080/xwiki";
          proxyWebsockets = true;
        };
      };

      # Paperless
      virtualHosts."paperless.home.arpa" = handleErrors {
        locations."/" = proxy 28981 {};
      };

      # Immich
      virtualHosts."immich.home.arpa" = handleErrors {
        locations."/" = proxy 2283 {};
        extraConfig = ''
          client_max_body_size 10000M;
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
          send_timeout       600s;
        '';
      };

      # Sunshine
      virtualHosts."sunshine.home.arpa" = handleErrors {
        locations."/" = proxy_s 47990 {};
      };

      # Syncthing
      virtualHosts."syncthing.home.arpa" = handleErrors {
        locations."/syncthing/" = {
          proxyPass = "http://localhost:8384/";
        };
        locations."/" = {
          extraConfig = ''return 301 http://syncthing.home.arpa/syncthing;'';
        };
      };

      # Arr Suite
      virtualHosts."bazarr.nixus.local" = handleErrors {
        locations."/" = proxy 6767 {};
      };
      virtualHosts."bazarr.home.arpa" = handleErrors {
        locations."/" = proxy 6767 {};
      };
      virtualHosts."arr.home.arpa" = handleErrors {
        locations = {
          "/prowlarr" = proxy 9696 {}; 
          "/lidarr" = proxy 8686 {};
          "/sonarr" = proxy 8989 {};
          "/radarr" = proxy 7878 {};
          "/readarr" = proxy 8787 {};
          "/bazarr" = proxy 6767 {};
          "/transmission" = proxy 9091 {};
        };
      };
      virtualHosts."arr.nixus.local" = virtualHosts."arr.home.arpa";


      # Jellyfin
      virtualHosts."jellyfin.home.arpa" = handleErrors {
        root = "/var/www/nixus";
        locations = {
          # Jellyfin
          "/" = proxy 8096 {
            extraConfig = ''
              proxy_pass_header Authorization;
              proxy_buffering off;
              client_max_body_size 50M;
            '';
          };
          "/socket" = proxy 8096 {};
        };
      };
      virtualHosts."jellyfin.nixus.local" = virtualHosts."jellyfin.home.arpa";


      # Jellyseerr
      virtualHosts."seer.home.arpa" = handleErrors {
        locations."/" = proxy 5055 {};
      };
      virtualHosts."jellyseerr.home.arpa" = virtualHosts."seer.home.arpa";
    };

  services.jellyfin = {
    enable = true;
    group = "media";
    dataDir = "/var/lib/jellyfin";
  };
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  services.jellyseerr = {
    enable = true;
  };


  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    group = "media";
    settings.umask = "774";
    settings.download-dir = "/media/downloads";
    downloadDirPermissions = "774";
    webHome = pkgs.flood-for-transmission;
  };

  # services.baikal = {
  #   enable = true; 
  #   virtualHost = "dav.home.arpa";
  # };

}
