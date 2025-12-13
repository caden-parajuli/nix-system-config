{ config, pkgs, ... }:
{
  services.paperless = {
    enable = true;
    consumptionDirIsPublic = true;
    passwordFile = config.age.secrets.paperlessPassword.path;
    settings = {
      PAPERLESS_URL = "http://paperless.nixus.local";
    };
  };
}
