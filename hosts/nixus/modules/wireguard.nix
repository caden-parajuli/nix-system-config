{ config, ... }:
{
  networking.firewall = {
    allowedUDPPorts = [ 51820 51822 ];
  };
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "172.30.202.2/32" ];
      mtu = 1380;
      listenPort = 51822;

      privateKeyFile = config.age.secrets.wireguardPrivate.path;

      peers = [
        {
          # Public key of the server
          publicKey = "cwxNI/pISWlKLZFqkqRjKJInlC2IjNt0Q2TWlKjBdGI=";
          allowedIPs = [ "172.30.202.0/24" ];
          endpoint = "173.255.238.237:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}

