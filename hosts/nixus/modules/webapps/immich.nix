{pkgs, ...}:
{
  services.immich = {
    enable = true;
    group = "media";
    host = "127.0.0.1";
    accelerationDevices = null;
    settings.server.externalDomain = "http://immich.home.arpa";
  };
}
