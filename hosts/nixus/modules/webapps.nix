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
    package = pkgs.nginx.override { openssl = pkgs.libressl; };
    enable = true;
    virtualHosts."nixus.bc.edu" = {
      # jellyfin
      locations =
        let proxy =
          port: extra: {
            proxyPass = "http://127.0.0.1:${toString port}";
            proxyWebsockets = true;
          } // extra;
        in
        {
        # Jellyfin
        "/" = proxy 8096 {
          extraConfig =
            ''proxy_pass_header Authorization;
              proxy_buffering off;''
            ;
        };
        "/socket" = proxy 8096 {};

        "/prowlarr" = proxy 9696 {}; 
        "/lidarr" = proxy 8686 {};
        "/sonarr" = proxy 8989 {};
        "/radarr" = proxy 7878 {};
        "/readarr" = proxy 8787 {};
        "/transmission" = proxy 9091 {};
        # "/paperless" = proxy 28981 {};
      };
    };
  };

  # services.paperless = {
  #   enable = true;
  #   port = 28981;
  #   settings = {
  #     DEBUG = true;
  #     PAPERLESS_URL = "nixus.bc.edu";
  #     PAPERLESS_FORCE_SCRIPT_NAME = "/paperless";
  #     PAPERLESS_STATIC_URL = "/paperless/static/";
  #     PAPERLESS_ADMIN_USER = "caden";
  #     PAPERLESS_ADMIN_PASSWORD = "password";
  #     USE_X_FORWARDED_PORT = true;
  #     USE_X_FORWARDED_HOST = true;
  #   };
  # };

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
    webHome = pkgs.flood-for-transmission;
  };

}
