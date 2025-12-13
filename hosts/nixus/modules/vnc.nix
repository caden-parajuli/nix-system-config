{ config, pkgs, ...}:
{
  programs.wayvnc = {
    enable = true;
  };

  systemd.user.services.wayvnc = {
    wantedBy = [ 
      "graphical-user.target"
    ];
    after = [
      "network-online.target"
    ];
    wants = [
      "network-online.target"
    ];
    path = [  ];
    serviceConfig = {
      ExecStart = "${config.programs.wayvnc.package}/bin/wayvnc 0.0.0.0";
      Restart = "on-failure";
      StateDirectory = "wayvnc";
    };
  };

  networking.firewall.allowedTCPPorts = [ 5900 ];
}
