{ config, pkgs, ... }:
{
  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = 9001;
    exporters = {
      node = {
        enable = true;
        listenAddress = "127.0.0.1";
        port = 9002;
        enabledCollectors = [ "systemd" ];
      };
      systemd = {
        enable = true;
        listenAddress = "127.0.0.1";
        port = 9003;
      };
    };
    scrapeConfigs = [
      {
        job_name = "nixus";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
          }
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.systemd.port}" ];
          }
        ];
      }
    ];
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = "grafana.home.arpa";
        http_addr = "0.0.0.0";
        enable_gzip = true;
      };
      analytics.reporting_enabled = false;
    };

    provision = {
      enable = true;

      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
          isDefault = true;
          editable = true;
        }
      ];
    };
  };

  services.nginx.virtualHosts."grafana.home.arpa" = {
    locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
    };
  };

}
