{ config, pkgs, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "cadenparajuli+acme@vivaldi.net";
      dnsProvider = "porkbun";

      environmentFile = config.age.secrets.porkbunKey.path;
      dnsPropagationCheck = false;
    };
    # certs."cadenp.com" = {
    #   extraDomainNames = [ "*.cadenp.com" ];
    #   dnsProvider = "porkbun";
    #   environmentFile = config.age.secrets.porkbunKey.path;
    #
    #   dnsPropagationCheck = false;
    # };
  };
}
