{pkgs, ...}:
{
  users.groups.media.members = [
    "caden"

    "paperless"
    "jellyfin"

    "lidarr"
    "sonarr"
    "radarr"
    "readarr"
    "transmission"
  ];

  services.nginx =
    let
      proxy = port: extra: {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true;
      } // extra;
      handleErrors = host: pkgs.lib.recursiveUpdate host {
        locations."/error" = {
          priority = 10;
          root = "/var/www/nixus";
          extraConfig = "internal;";
        };

        extraConfig = ''
        proxy_intercept_errors on;
        error_page 403 /error/403.html;
        error_page 404 /error/404.html;
        error_page 500 501 502 503 504 /error/5xx.html;
        '';
       };
    in rec {
      enable = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      # XWiki
      virtualHosts."xwiki.nixus.local" = handleErrors {
        locations."/" = {
          extraConfig = ''return 301 http://xwiki.nixus.local/xwiki;'';
        };
        locations."/xwiki" = {
          proxyPass = "http://127.0.0.1:8080/xwiki";
          proxyWebsockets = true;
        };
      };

      # Sunshine
      virtualHosts."sunshine.nixus.local" = handleErrors {
        locations."/" = {
          proxyPass = "https://127.0.0.1:47990";
          proxyWebsockets = true;
        };
      };

      # Arr Suite
      virtualHosts."arr.nixus.local" = handleErrors {
        locations = {
          "/prowlarr" = proxy 9696 {}; 
          "/lidarr" = proxy 8686 {};
          "/sonarr" = proxy 8989 {};
          "/radarr" = proxy 7878 {};
          "/readarr" = proxy 8787 {};
          "/transmission" = proxy 9091 {};
        };
      };

      # Jellyfin
      virtualHosts."jellyfin.nixus.local" = handleErrors {
        root = "/var/www/nixus";
        locations = {
          # Jellyfin
          "/" = proxy 8096 {
            extraConfig =
              ''proxy_pass_header Authorization;
              proxy_buffering off;''
              ;
          };
          "/socket" = proxy 8096 {};
        };

      };
      virtualHosts."www.nixus.local" = virtualHosts."jellyfin.nixus.local";
    };

  services.jellyfin = {
    enable = true;
    group = "media";
    dataDir = "/var/lib/jellyfin";
  };


  services.transmission = {
    enable = true;
    group = "media";
    settings.umask = "774";
    settings.download-dir = "/media/downloads";
    downloadDirPermissions = "774";
    webHome = pkgs.flood-for-transmission;
  };

  services.baikal = {
    enable = true; 
    virtualHost = "dav.nixus.local";
  };
  services.prowlarr = {
    enable = true;
  };
  services.lidarr = {
    enable = true;
    group = "media";
  };
  services.sonarr = {
    enable = true;
    group = "media";
  };
  services.radarr = {
    enable = true;
    group = "media";
  };
  services.readarr = {
    enable = true;
    group = "media";
  };

}
