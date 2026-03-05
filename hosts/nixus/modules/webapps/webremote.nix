{ inputs, config, pkgs, ... }:
{
  services.webremote = {
    enable = true;
    interface = "0.0.0.0";
    port = 42070;
    settings = {
      window_manager = "Hypr";
      apps = [
        {
          name = "kodi";
          pretty_name = "Kodi";
          app_id = "Kodi";
          launch_command = "kodi";
          default_workspace = 1;
        }
        {
          name = "youtube";
          pretty_name = "YouTube";
          app_id = "vacuumtube";
          launch_command = "VacuumTube";
          default_workspace = 2;
        }
      ];
    };
  };

  services.nginx.virtualHosts."remote.cadenp.com" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.webremote.port}";
      proxyWebsockets = true;
    };
  };

  users.users.caden.extraGroups = [ config.programs.ydotool.group ];
}
