{ config, ... }:
{
  networking.firewall = {
    allowedUDPPorts = [ 51820 51822 ];
  };
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.0.0.2/32" ];
      mtu = 1380;
      listenPort = 51822;

      privateKeyFile = config.age.secrets.wireguardPrivate.path;

      peers = [
        {
          # Public key of the server
          publicKey = "cwxNI/pISWlKLZFqkqRjKJInlC2IjNt0Q2TWlKjBdGI=";
          allowedIPs = [ "10.0.0.0/24" ];
          endpoint = "34.230.82.168:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
