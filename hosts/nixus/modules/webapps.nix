{pkgs, ...}:
{
  # environment.systemPackages = with pkgs; [
  # ];

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

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts."nixus.bc.edu" = {
      root = "/var/www/nixus";
      locations =
        let proxy =
          port: extra: {
            proxyPass = "http://127.0.0.1:${toString port}";
            proxyWebsockets = true;
          } // extra;
        in {
          # Jellyfin
          "/" = proxy 8096 {
            extraConfig =
              ''proxy_pass_header Authorization;
              proxy_buffering off;''
              ;
          };
          "/socket" = proxy 8096 {};

          "/xwiki" = {
            proxyPass = "http://127.0.0.1:8080/xwiki";
            proxyWebsockets = true;
          };

          "/prowlarr" = proxy 9696 {}; 
          "/lidarr" = proxy 8686 {};
          "/sonarr" = proxy 8989 {};
          "/radarr" = proxy 7878 {};
          "/readarr" = proxy 8787 {};
          "/transmission" = proxy 9091 {};

          "/error" = {
            priority = 10;
            root = "/var/www/nixus";
            extraConfig = "internal;";
          };
        };

      extraConfig = ''
        proxy_intercept_errors on;
        error_page 403 /error/403.html;
        error_page 404 /error/404.html;
        error_page 500 501 502 503 504 /error/5xx.html;
      '';
    };
  };

  services.jellyfin = {
    enable = true;
    group = "media";
    dataDir = "/var/lib/jellyfin";
  };


  # Arr suite

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

  services.transmission = {
    enable = true;
    group = "media";
    settings.umask = "774";
    settings.download-dir = "/media/downloads";
    downloadDirPermissions = "774";
    webHome = pkgs.flood-for-transmission;
  };

}
