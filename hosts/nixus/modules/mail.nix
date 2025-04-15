{ config, pkgs, ... }:
{
  age.secrets.cadenGmail = {
    file = ./../secrets/cadenGmailPassword.age;
    owner = "caden";
    group = "users";
  };
  programs.msmtp = {
    enable = true;
    setSendmail = true;
    defaults = {
      aliases = pkgs.writeText "aliases" ''
        root: caden.parajuli@gmail.com
        '';
      port = 465;
      tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
      tls = "on";
      auth = "login";
      tls_starttls = "on";
    };
    accounts = {
      default = {
        auth = true;
        tls = true;
        tls_starttls = true;
        host = "smtp.gmail.com";
        port = 587;
        passwordeval = "cat ${config.age.secrets.cadenGmail.path}";
        user = "caden.parajuli@gmail.com";
        from = "Caden Parajuli";
      };
    };
  };
}
