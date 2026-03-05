{ ... }:
{
  services.nginx.virtualHosts."cfh.wapp.wii.com" = {
    root = "/var/www/wii";
    locations = {
      "/".extraConfig = ''
        rewrite ^/eula/(.*)/(.*)$ /haxs/$2 last;
      '';
      "/haxs".extraConfig = ''
        try_files $uri $uri/index.html /haxs/index.html;
      '';
    };
    extraConfig = ''
      rewrite_log on;
    '';
  };
}
