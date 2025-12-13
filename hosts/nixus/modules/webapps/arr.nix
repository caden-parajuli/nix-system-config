{pkgs, ...}:
{
  services.prowlarr = {
    enable = true;
  };

  services.lidarr = {
    enable = true;
    group = "media";
    package = pkgs.lidarr;
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

  services.bazarr = {
    enable = true;
    group = "media";
  };

}
